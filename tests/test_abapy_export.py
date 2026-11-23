import importlib.util
import ast
import os
from pathlib import Path
import sys
import tempfile
import types
import unittest
from unittest.mock import patch


SCRIPT = Path(__file__).resolve().parents[1] / "matlab_code" / "fem" / "abapy_export.py"
spec = importlib.util.spec_from_file_location("nims_abapy_export", SCRIPT)
bridge = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bridge)


class BridgeTests(unittest.TestCase):
    def test_multilayer_mesh_has_shared_interfaces_and_correct_regions(self):
        films = [(100.0, 90.0, 0.32), (200.0, 120.0, 0.34),
                 (500.0, 70.0, 0.18)]
        model = bridge.build_layered_mesh(films, 2000.0, 3000.0, 4, 2, 4)
        coords = {label: (x, y) for label, x, y in model["nodes"]}
        self.assertEqual(len(coords), 55)
        self.assertEqual(len(set(coords.values())), len(coords))
        bounds = {"FILM_1": (-100, 0), "FILM_2": (-300, -100),
                  "FILM_3": (-800, -300), "SUBSTRATE": (-2800, -800)}
        region_nodes = {name: set() for name in bounds}
        areas = {name: 0 for name in bounds}
        for label, connectivity, region in model["elements"]:
            points = [coords[node] for node in connectivity]
            area = sum(points[i][0] * points[(i + 1) % 4][1] -
                       points[(i + 1) % 4][0] * points[i][1] for i in range(4)) / 2
            self.assertGreater(area, 0)
            self.assertGreaterEqual(min(y for x, y in points), bounds[region][0])
            self.assertLessEqual(max(y for x, y in points), bounds[region][1])
            areas[region] += area
            region_nodes[region].update(connectivity)
        for name, (bottom, top) in bounds.items():
            self.assertEqual(areas[name], 3000 * (top - bottom))
        for upper, lower in (("FILM_1", "FILM_2"), ("FILM_2", "FILM_3"),
                             ("FILM_3", "SUBSTRATE")):
            shared = region_nodes[upper] & region_nodes[lower]
            self.assertEqual(len(shared), 5)
            self.assertEqual({coords[node][1] for node in shared}, {bounds[upper][0]})
        self.assertEqual({coords[n][1] for n in model["node_sets"]["top_nodes"]}, {0})
        surface = set(model["surface_elements"])
        for label, conn, region in model["elements"]:
            if label in surface:
                self.assertEqual((coords[conn[2]][1], coords[conn[3]][1]), (0, 0))

    def test_layered_deck_assigns_each_region_without_global_sample_section(self):
        materials = [(name, "*MATERIAL, NAME={}\n*ELASTIC\n{}, {}\n".format(name, e, nu))
                     for name, e, nu in [("FILM_1", 90, 0.32), ("FILM_2", 120, 0.34),
                                         ("SUBSTRATE", 165, 0.28), ("INDENTER_MAT", 165, 0.28)]]
        deck = bridge.layered_deck("*NODE\n", "*RIGID BODY\n", materials, "*STEP\n*END STEP\n")
        self.assertEqual(deck.count("*SOLID SECTION"), 3)
        for name, text in materials[:-1]:
            self.assertIn("*SOLID SECTION, ELSET={}, MATERIAL={}".format(name, name), deck)
            self.assertIn(text, deck)
        self.assertNotIn("ELSET=ALL_ELEMENTS, MATERIAL=", deck)
        self.assertIn("I_SAMPLE.SURFACE_FACES, I_INDENTER.SURFACE_FACES", deck)

    def test_prepares_portable_script_without_abapy_and_rejects_overwrite(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "multilayer.py"
            args = ["--prepare-script", "--output", str(output),
                    "--young", "165", "--poisson", "0.28", "--depth", "200",
                    "--mesh-size", "600", "--film", "500", "90", "0.32",
                    "--substrate-depth", "6000", "--width", "6000"]
            with patch.dict(sys.modules, {"abapy": None}):
                bridge.main(args)
            text = output.read_text()
            tree = ast.parse(text)
            baked_args = ast.literal_eval(tree.body[-1].body[0].value.args[0])
            self.assertEqual(baked_args[baked_args.index("--output") + 1], "multilayer.inp")
            self.assertIn("--film", baked_args)
            self.assertNotIn("--prepare-script", baked_args)
            compile(text, str(output), "exec")
            with self.assertRaises(OSError):
                bridge.main(args)
            self.assertEqual(output.read_text(), text)

    def test_passes_bulk_parameters_to_abapy_and_preserves_existing_file(self):
        calls = {}
        indentation = types.ModuleType("abapy.indentation")
        materials = types.ModuleType("abapy.materials")

        def capture(name):
            def factory(**kwargs):
                calls.setdefault(name, []).append(kwargs)
                return (name, kwargs)
            return factory

        indentation.IndentationMesh = capture("mesh")
        indentation.DeformableCone2D = capture("cone")
        indentation.Step = capture("step")
        materials.Elastic = capture("material")

        def make_inp(**kwargs):
            calls["deck"] = kwargs
            return "test deck\n"

        indentation.MakeInp = make_inp
        modules = {"abapy": types.ModuleType("abapy"),
                   "abapy.indentation": indentation, "abapy.materials": materials}
        with tempfile.TemporaryDirectory() as directory, patch.dict(sys.modules, modules):
            output = os.path.join(directory, "bulk.inp")
            args = ["--output", output, "--young", "165", "--poisson", "0.28",
                    "--depth", "200", "--mesh-size", "600", "--angle", "70.3"]
            bridge.main(args)
            self.assertEqual(Path(output).read_text(), "test deck\n")
            with self.assertRaises(OSError):
                bridge.main(args)
            self.assertEqual(Path(output).read_text(), "test deck\n")
        self.assertEqual(calls["mesh"][0]["name"], "CAX4")
        self.assertEqual(calls["cone"][0]["rigid"], True)
        self.assertEqual(calls["material"][0]["E"], 165)
        self.assertEqual(calls["material"][0]["nu"], 0.28)
        self.assertEqual([step["disp"] for step in calls["step"][:2]], [200, 0])
        self.assertFalse(calls["deck"]["is_3D"])
        self.assertEqual(calls["deck"]["friction"], 0)

    def test_rejects_invalid_inputs_before_import(self):
        base = ["--output", "bulk.inp", "--young", "165", "--poisson", "0.28",
                "--depth", "200", "--mesh-size", "600"]
        for extra in (["--young", "nan"], ["--poisson", "0.5"],
                      ["--angle", "90"], ["--mesh-size", "200"],
                      ["--output", "bulk.py"], ["--film", "0", "90", "0.3"],
                      ["--film", "500", "90", "0.3"]):
            with self.subTest(extra=extra), self.assertRaises(SystemExit):
                bridge.main(base + extra)


if __name__ == "__main__":
    unittest.main()
