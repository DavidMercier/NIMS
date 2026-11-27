"""Configure an imported NIMS indentation geometry in Ansys Mechanical.

Run through workbench_indentation.wbjn after creating its Engineering Data.
This script prepares the model; it does not mesh or solve it.
"""

indentation_depth_um = 0.2
global_element_size_um = 2.0
elements_through_each_layer = 3


def selection(ids):
    result = ExtAPI.SelectionManager.CreateSelectionInfo(SelectionTypeEnum.GeometryEntities)
    result.Ids = list(ids)
    return result


def short_name(body):
    return body.Name.split("\\")[-1]


def horizontal_faces(body):
    faces = sorted(body.GetGeoBody().Faces, key=lambda face: face.Centroid[2])
    if len(faces) != 3:
        raise ValueError("{} must be a cylindrical body with three faces".format(body.Name))
    return faces[0], faces[-1]


def contact(name, source, target, contact_type):
    region = Model.Connections.AddContactRegion()
    region.Name = name
    region.ContactType = contact_type
    region.SourceLocation = selection(source)
    region.TargetLocation = selection(target)
    return region


if not 0 < indentation_depth_um < float("inf"):
    raise ValueError("indentation_depth_um must be finite and positive")
if (not 0 < global_element_size_um < float("inf") or
        not isinstance(elements_through_each_layer, int) or elements_through_each_layer < 1):
    raise ValueError("Mesh sizes and elements_through_each_layer must be positive")

bodies = {}
for body in ExtAPI.DataModel.GetObjectsByType(DataModelObjectCategory.Body):
    name = short_name(body)
    if name in bodies:
        raise ValueError("Duplicate body name: {}".format(name))
    bodies[name] = body
if "Substrate_Silicon" not in bodies or "Indenter" not in bodies:
    raise ValueError("Expected Substrate_Silicon and Indenter bodies")

layers = []
for index in range(1, 4):
    prefix = "Layer_{}_".format(index)
    matches = [name for name in bodies if name.startswith(prefix)]
    if len(matches) > 1:
        raise ValueError("Multiple bodies for layer {}".format(index))
    if matches:
        if index != len(layers) + 1:
            raise ValueError("Layer numbering must be consecutive from the top")
        material = matches[0][len(prefix):]
        layers.append((bodies[matches[0]], material))
if not layers or len(bodies) != len(layers) + 2:
    raise ValueError("Expected one to three layers, a substrate and an indenter only")

available_materials = set(child.Name for child in Model.Materials.Children)
for material in ["Silicon"] + [name for body, name in layers]:
    if "NIMS_example_" + material not in available_materials:
        raise ValueError("Missing Engineering Data material: NIMS_example_" + material)

substrate = bodies["Substrate_Silicon"]
indenter = bodies["Indenter"]
substrate.Material = "NIMS_example_Silicon"
indenter.StiffnessBehavior = StiffnessBehavior.Rigid
for body, material in layers:
    body.Material = "NIMS_example_" + material

# The script creates an entirely new model. Remove automatically detected
# contacts before explicitly defining the intended interfaces.
for region in list(ExtAPI.DataModel.GetObjectsByType(DataModelObjectCategory.ContactRegion)):
    region.Delete()

stack = [body for body, material in layers] + [substrate]
for index in range(len(stack) - 1):
    upper_bottom, _ = horizontal_faces(stack[index])
    _, lower_top = horizontal_faces(stack[index + 1])
    contact("Bonded_interface_{}".format(index + 1),
            [upper_bottom.Id], [lower_top.Id], ContactType.Bonded)

_, sample_top = horizontal_faces(layers[0][0])
tip_faces = sorted(indenter.GetGeoBody().Faces, key=lambda face: face.Centroid[2])
if len(tip_faces) != 3:
    raise ValueError("Indenter must have spherical, conical and top faces")
contact("Frictionless_indenter", [sample_top.Id],
        [tip_faces[0].Id, tip_faces[1].Id], ContactType.Frictionless)

analysis = Model.Analyses[0]
settings = analysis.AnalysisSettings
settings.NumberOfSteps = 2
settings.SetStepEndTime(1, Quantity("1 [s]"))
settings.SetStepEndTime(2, Quantity("2 [s]"))
settings.LargeDeflection = True
for step in (1, 2):
    settings.SetAutomaticTimeStepping(step, AutomaticTimeStepping.On)
    settings.SetDefineBy(step, TimeStepDefineByType.Substeps)
    settings.SetInitialSubsteps(step, 40)
    settings.SetMinimumSubsteps(step, 10)
    settings.SetMaximumSubsteps(step, 1000)

substrate_bottom, _ = horizontal_faces(substrate)
support = analysis.AddFixedSupport()
support.Name = "Fixed_substrate_bottom"
support.Location = selection([substrate_bottom.Id])
displacement = analysis.AddRemoteDisplacement()
displacement.Name = "Indentation_load_unload"
displacement.Location = selection([tip_faces[-1].Id])
displacement.XComponent.Output.DiscreteValues = [Quantity("0 [um]")]
displacement.YComponent.Output.DiscreteValues = [Quantity("0 [um]")]
displacement.RotationX.Output.DiscreteValues = [Quantity("0 [deg]")]
displacement.RotationY.Output.DiscreteValues = [Quantity("0 [deg]")]
displacement.RotationZ.Output.DiscreteValues = [Quantity("0 [deg]")]
displacement.ZComponent.Inputs[0].DiscreteValues = [
    Quantity("0 [s]"), Quantity("1 [s]"), Quantity("2 [s]")]
displacement.ZComponent.Output.DiscreteValues = [
    Quantity("0 [um]"), Quantity("-{} [um]".format(indentation_depth_um)),
    Quantity("0 [um]")]

Model.Mesh.ElementSize = Quantity("{} [um]".format(global_element_size_um))
for body, material in layers:
    bottom, top = horizontal_faces(body)
    thickness_m = top.Centroid[2] - bottom.Centroid[2]
    sizing = Model.Mesh.AddSizing()
    sizing.Name = "Sizing_" + short_name(body)
    sizing.Location = selection([body.GetGeoBody().Id])
    sizing.ElementSize = Quantity("{} [m]".format(thickness_m / elements_through_each_layer))

reaction = analysis.Solution.AddForceReaction()
reaction.Name = "Indenter_reaction"
reaction.BoundaryConditionSelection = displacement
reaction.DisplayTime = Quantity("1 [s]")
analysis.Solution.AddEquivalentStress()
analysis.Solution.AddTotalDeformation()
ExtAPI.DataModel.Tree.Refresh()
