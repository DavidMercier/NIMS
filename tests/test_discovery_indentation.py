import ast
import math
from pathlib import Path
import re
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "matlab_code" / "fem" / "discovery_indentation_geometry.py"


def geometry_namespace(layers):
    tree = ast.parse(SCRIPT.read_text(encoding="utf-8"))
    functions = [node for node in tree.body
                 if isinstance(node, ast.FunctionDef) and node.name in ("positive", "create_geometry")]
    namespace = {"math": math, "re": re}
    exec(compile(ast.Module(body=functions, type_ignores=[]), str(SCRIPT), "exec"), namespace)

    class Part:
        def __init__(self):
            self.Bodies = []
            self.Components = []

    calls = []
    view_calls = []
    part = Part()

    def cylinder(part, name, radius, thickness, top):
        calls.append((name, radius, thickness, top))
        part.Bodies.append(name)

    def rounded_cone(part, radius, angle, height):
        calls.append(("Indenter", radius, angle, height))
        part.Bodies.append("Indenter")

    class Selection:
        @staticmethod
        def Create(bodies):
            return tuple(bodies)

    class ViewHelper:
        @staticmethod
        def ActivateNamedView(name, animate):
            view_calls.append(("view", name, animate))

        @staticmethod
        def ZoomToEntity(selection):
            view_calls.append(("zoom", selection))

    namespace.update({
        "tip_radius_um": 7.4,
        "cone_half_angle_deg": 70.3,
        "indenter_height_um": 14.8,
        "sample_radius_um": 18.5,
        "substrate_thickness_um": 37.0,
        "layers": layers,
        "GetRootPart": lambda: part,
        "cylinder": cylinder,
        "rounded_cone": rounded_cone,
        "ViewHelper": ViewHelper,
        "Selection": Selection,
        "view_calls": view_calls,
    })
    return namespace, calls


class DiscoveryGeometryTests(unittest.TestCase):
    def test_layer_counts_and_interface_positions(self):
        layers = [("SiO2", 0.1), ("Al", 0.2), ("Al2O3", 0.3)]
        for count in (1, 2, 3):
            with self.subTest(count=count):
                ns, calls = geometry_namespace(layers[:count])
                ns["create_geometry"]()
                self.assertEqual(len(calls), count + 2)
                top = 0.0
                for index, (material, thickness) in enumerate(layers[:count]):
                    name, radius, actual_thickness, actual_top = calls[index]
                    self.assertEqual(name, "Layer_{}_{}".format(index + 1, material))
                    self.assertAlmostEqual(radius, 18.5e-6)
                    self.assertAlmostEqual(actual_thickness, thickness * 1e-6)
                    self.assertAlmostEqual(actual_top, top)
                    top -= thickness * 1e-6
                self.assertEqual(calls[-2][0], "Substrate_Silicon")
                self.assertAlmostEqual(calls[-2][3], top)
                self.assertEqual(calls[-1][0], "Indenter")

    def test_invalid_inputs_fail_before_creating_bodies(self):
        for layers, changes in [
                ([], {}), ([("Al", 1)] * 4, {}),
                ([("Al", 0)], {}), ([("bad/name", 1)], {}),
                ([("Al", 1)], {"tip_radius_um": float("nan")}),
                ([("Al", 1)], {"cone_half_angle_deg": 90}),
                ([("Al", 1)], {"indenter_height_um": 0.001})]:
            with self.subTest(layers=layers, changes=changes):
                ns, calls = geometry_namespace(layers)
                ns.update(changes)
                with self.assertRaises(ValueError):
                    ns["create_geometry"]()
                self.assertEqual(calls, [])

    def test_existing_geometry_is_not_modified(self):
        ns, calls = geometry_namespace([("Al", 1)])
        ns["GetRootPart"] = lambda: type("Part", (), {"Bodies": [object()], "Components": []})()
        with self.assertRaisesRegex(ValueError, "empty document"):
            ns["create_geometry"]()
        self.assertEqual(calls, [])

    def test_custom_material_names_are_preserved(self):
        ns, calls = geometry_namespace([("Ti_6Al4V", 1)])
        ns["create_geometry"]()
        self.assertEqual(calls[0][0], "Layer_1_Ti_6Al4V")

    def test_view_includes_specimen_and_indenter(self):
        ns, calls = geometry_namespace([("SiO2", 0.1), ("Al", 0.2)])
        ns["create_geometry"]()
        self.assertEqual(ns["view_calls"], [
            ("view", "Isometric", True),
            ("zoom", tuple(call[0] for call in calls)),
        ])


if __name__ == "__main__":
    unittest.main()
