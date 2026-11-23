"""Export a bulk or multilayer axisymmetric indentation input using Abapy.

Run this script with the Python interpreter in which Abapy is installed.
Lengths are in nm and moduli are in GPa.
"""
from __future__ import print_function

import argparse
import math
import os


def build_layered_mesh(films, substrate_depth, width, radial_elements,
                       layer_elements, substrate_elements):
    """Return an interface-conforming mesh; films are surface to substrate."""
    regions = [("FILM_{}".format(i + 1), film[0], film[1], film[2],
                layer_elements) for i, film in enumerate(films)]
    regions.append(("SUBSTRATE", substrate_depth, None, None, substrate_elements))
    y = [-sum(region[1] for region in regions)]
    row_regions = []
    for name, thickness, young, nu, count in reversed(regions):
        bottom = y[-1]
        y.extend(bottom + thickness * i / count for i in range(1, count + 1))
        row_regions.extend([name] * count)
    y[-1] = 0.0
    if any(b <= a for a, b in zip(y, y[1:])):
        raise ValueError("Layer dimensions do not produce distinct mesh rows.")
    stride = radial_elements + 1
    nodes = [(j * stride + i + 1, width * i / radial_elements, height)
             for j, height in enumerate(y) for i in range(stride)]
    elements = []
    for j, region in enumerate(row_regions):
        for i in range(radial_elements):
            lower_left = j * stride + i + 1
            elements.append((len(elements) + 1,
                             (lower_left, lower_left + 1,
                              lower_left + stride + 1, lower_left + stride),
                             region))
    return {"nodes": nodes, "elements": elements, "regions": regions,
            "node_sets": {"axis_nodes": [j * stride + 1 for j in range(len(y))],
                          "bottom_nodes": list(range(1, stride + 1)),
                          "top_nodes": list(range((len(y) - 1) * stride + 1,
                                                 len(y) * stride + 1))},
            "surface_elements": list(range(len(elements) - radial_elements + 1,
                                           len(elements) + 1))}


def layered_sample(model):
    from abapy.mesh import Mesh, Nodes

    nodes = Nodes(dtf="d", sets={})
    for label, x, y in model["nodes"]:
        nodes.add_node(label=label, x=x, y=y, z=0.0)
    for name, labels in model["node_sets"].items():
        nodes.add_set(name, labels)
    mesh = Mesh(nodes=nodes, sets={}, surfaces={})
    for label, connectivity, region in model["elements"]:
        mesh.add_element(label=label, connectivity=connectivity,
                         space=2, name="CAX4", toset=region)
    mesh.add_set("all_elements", [element[0] for element in model["elements"]])
    mesh.add_set("surface_elements", model["surface_elements"])
    mesh.add_surface("surface_faces", [("surface_elements", 3)])
    return mesh


def layered_deck(sample_text, indenter_text, materials, step_text):
    # MakeInp assigns all sample elements one material; assemble per-region
    # sections instead, using the same Abapy mesh, indenter and Step exporters.
    sections = "\n".join("*SOLID SECTION, ELSET={}, MATERIAL={}\n,".format(name, name)
                         for name, text in materials[:-1])
    return """*HEADING
NIMS Abapy multilayer axisymmetric indentation (nm, GPa, nN)
*PART, NAME=P_SAMPLE
{sample}
{sections}
*END PART
*PART, NAME=P_INDENTER
{indenter}
*END PART
*ASSEMBLY, NAME=ASSEMBLY
*INSTANCE, NAME=I_SAMPLE, PART=P_SAMPLE
*END INSTANCE
*INSTANCE, NAME=I_INDENTER, PART=P_INDENTER
*END INSTANCE
*END ASSEMBLY
*SURFACE INTERACTION, NAME=SURF_INT
*FRICTION
0.
*SURFACE BEHAVIOR, PRESSURE-OVERCLOSURE=HARD
*CONTACT PAIR, INTERACTION=SURF_INT, TYPE=NODE TO SURFACE
I_SAMPLE.SURFACE_FACES, I_INDENTER.SURFACE_FACES
{materials}
{steps}
""".format(sample=sample_text, sections=sections, indenter=indenter_text,
           materials="\n".join(text for name, text in materials), steps=step_text)


def positive(value):
    number = float(value)
    if math.isnan(number) or math.isinf(number):
        raise argparse.ArgumentTypeError("must be finite")
    if number <= 0:
        raise argparse.ArgumentTypeError("must be positive")
    return number


def poisson(value):
    number = float(value)
    if math.isnan(number) or math.isinf(number) or not -1 < number < 0.5:
        raise argparse.ArgumentTypeError("Poisson ratio must be finite and between -1 and 0.5")
    return number


def angle(value):
    number = positive(value)
    if number >= 90:
        raise argparse.ArgumentTypeError("half angle must be less than 90 degrees")
    return number


def positive_integer(value):
    number = int(value)
    if number <= 0:
        raise argparse.ArgumentTypeError("must be a positive integer")
    return number


def write_new(path, text):
    fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o666)
    with os.fdopen(fd, "w") as stream:
        stream.write(text)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, help="new Abaqus .inp file")
    parser.add_argument("--young", type=positive, required=True, help="sample Young modulus in GPa")
    parser.add_argument("--poisson", type=poisson, required=True, help="sample Poisson ratio")
    parser.add_argument("--depth", type=positive, required=True, help="maximum indentation depth in nm")
    parser.add_argument("--mesh-size", type=positive, required=True, help="fine mesh region size in nm")
    parser.add_argument("--angle", type=angle, default=70.3, help="cone half angle in degrees")
    parser.add_argument("--film", nargs=3, action="append", default=[],
                        metavar=("THICKNESS", "YOUNG", "POISSON"),
                        help="film nm, GPa, nu; repeat from surface toward substrate")
    parser.add_argument("--substrate-depth", type=positive, help="substrate depth in nm")
    parser.add_argument("--width", type=positive, help="sample radial extent in nm")
    parser.add_argument("--radial-elements", type=positive_integer, default=64)
    parser.add_argument("--layer-elements", type=positive_integer, default=16)
    parser.add_argument("--substrate-elements", type=positive_integer, default=32)
    parser.add_argument("--prepare-script", action="store_true",
                        help="write a self-contained .py generator without importing Abapy")
    args = parser.parse_args(argv)
    extension = ".py" if args.prepare_script else ".inp"
    if not args.output.lower().endswith(extension):
        parser.error("output must end in {}".format(extension))
    if args.depth >= args.mesh_size:
        parser.error("mesh-size must exceed the indentation depth")
    try:
        films = [(positive(t), positive(e), poisson(nu)) for t, e, nu in args.film]
    except (ValueError, argparse.ArgumentTypeError) as error:
        parser.error(str(error))
    if films and (args.substrate_depth is None or args.width is None):
        parser.error("multilayer models require --substrate-depth and --width")
    if films and args.width <= args.depth * math.tan(math.radians(args.angle)):
        parser.error("sample width must exceed the nominal cone contact radius")
    model = None
    if films:
        model = build_layered_mesh(films, args.substrate_depth, args.width,
                                   args.radial_elements, args.layer_elements,
                                   args.substrate_elements)
    if args.prepare_script:
        options = ["--output", os.path.splitext(os.path.basename(args.output))[0] + ".inp",
                   "--young", str(args.young), "--poisson", str(args.poisson),
                   "--depth", str(args.depth), "--mesh-size", str(args.mesh_size),
                   "--angle", str(args.angle)]
        for film in films:
            options.extend(["--film"] + [str(value) for value in film])
        if films:
            options.extend(["--substrate-depth", str(args.substrate_depth),
                            "--width", str(args.width),
                            "--radial-elements", str(args.radial_elements),
                            "--layer-elements", str(args.layer_elements),
                            "--substrate-elements", str(args.substrate_elements)])
        with open(__file__, "r") as source:
            code = source.read().split('\nif __name__ == "__main__":')[0]
        write_new(args.output, code + '\n\nif __name__ == "__main__":\n    main({!r})\n'.format(options))
        print("Wrote Abapy generator (Abapy not needed until execution): {}".format(args.output))
        return

    from abapy.indentation import DeformableCone2D, IndentationMesh, MakeInp, Step
    from abapy.materials import Elastic

    mesh_options = dict(Na=8, Nb=8, Ns=16, Nf=2, l=args.mesh_size)
    sample = layered_sample(model) if model is not None else IndentationMesh(name="CAX4", **mesh_options)
    indenter = DeformableCone2D(half_angle=args.angle, rigid=True, **mesh_options)
    sample_material = Elastic(labels="SAMPLE_MAT", E=args.young, nu=args.poisson)
    indenter_material = Elastic(labels="INDENTER_MAT", E=args.young, nu=args.poisson)
    steps = [Step(name="loading", disp=args.depth),
             Step(name="unloading", disp=0.0)]
    if model is None:
        deck = MakeInp(sample_mesh=sample, indenter=indenter, sample_mat=sample_material,
                       indenter_mat=indenter_material, friction=0.0, steps=steps,
                       is_3D=False, heading="NIMS Abapy homogeneous indentation")
    else:
        materials = [(name, Elastic(labels=name, E=young if young is not None else args.young,
                                    nu=nu if nu is not None else args.poisson).dump2inp())
                     for name, thickness, young, nu, count in model["regions"]]
        materials.append(("INDENTER_MAT", indenter_material.dump2inp()))
        deck = layered_deck(sample.dump2inp(), indenter.dump2inp(), materials,
                            "\n".join(step.dump2inp() for step in steps))
    write_new(args.output, deck)
    print("Wrote {} axisymmetric input: {}".format(
        "multilayer" if model is not None else "homogeneous", args.output))



if __name__ == "__main__":
    main(['--output', 'MTS_3films_Au-Ti-SiO2-Si_CSM-1nm_2D.inp', '--young', '165.0', '--poisson', '0.28', '--depth', '200.0', '--mesh-size', '600.0', '--angle', '70.3', '--film', '500.0', '93.61', '0.32', '--film', '500.0', '120.0', '0.34', '--film', '500.0', '70.0', '0.18', '--substrate-depth', '6000.0', '--width', '6000.0', '--radial-elements', '64', '--layer-elements', '16', '--substrate-elements', '32'])
