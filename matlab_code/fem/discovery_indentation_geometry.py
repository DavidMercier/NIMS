# Python Script, API Version = V242
"""Create a multilayer indentation geometry in Ansys Discovery/SpaceClaim.

Run in a new, empty document with the model length scale set to Small.
Dimensions below are in micrometres; layers are ordered from top to bottom.
"""
import math
import re
from System.Collections.Generic import List

# Use the API version of the active editor, not a second versioned assembly.
api = __import__(GetRootPart().GetType().Assembly.GetName().Name,
                 fromlist=["Geometry", "Modeler", "DesignBody"])
Geometry, Modeler, DesignBody = api.Geometry, api.Modeler, api.DesignBody

# Edit these parameters before running the script.
tip_radius_um = 7.4
cone_half_angle_deg = 70.3
indenter_height_um = 14.8
sample_radius_um = 18.5
substrate_thickness_um = 37.0
layers = [("SiO2", 0.1), ("Al", 0.2), ("Al2O3", 0.3)]


def positive(value, name):
    if not isinstance(value, (int, float)) or not 0 < value < float("inf"):
        raise ValueError("{} must be a finite positive number".format(name))


def cylinder(part, name, radius, thickness, top):
    profile = Geometry.CircleProfile(
        Geometry.Plane.PlaneXY, radius, Geometry.PointUV.Create(0, 0), 0)
    solid = Modeler.Body.ExtrudeProfile(profile, -thickness)
    body = DesignBody.Create(part, name, solid)
    body.Transform(Geometry.Matrix.CreateTranslation(
        Geometry.Vector.Create(0, 0, top)))
    return body


def rounded_cone(part, radius, angle, height):
    transition_z = radius * (1 - math.sin(angle))
    transition_r = radius * math.cos(angle)
    if height <= transition_z:
        raise ValueError("Indenter height must extend beyond the spherical cap")
    top_r = transition_r + (height - transition_z) * math.tan(angle)
    origin = Geometry.Point.Create(0, 0, 0)
    center = Geometry.Point.Create(0, 0, radius)
    frame = Geometry.Frame.Create(center, Geometry.Direction.DirX, Geometry.Direction.DirZ)
    circle = Geometry.Circle.Create(frame, radius)
    boundary = List[Geometry.ITrimmedCurve]()
    boundary.Add(Geometry.CurveSegment.Create(
        circle, Geometry.Interval.Create(-math.pi / 2, -angle)))
    transition = Geometry.Point.Create(transition_r, 0, transition_z)
    outer_top = Geometry.Point.Create(top_r, 0, height)
    axis_top = Geometry.Point.Create(0, 0, height)
    boundary.Add(Geometry.CurveSegment.Create(transition, outer_top))
    boundary.Add(Geometry.CurveSegment.Create(outer_top, axis_top))
    boundary.Add(Geometry.CurveSegment.Create(axis_top, origin))
    path = List[Geometry.ITrimmedCurve]()
    path_frame = Geometry.Frame.Create(origin, Geometry.Direction.DirX, Geometry.Direction.DirY)
    path.Add(Geometry.CurveSegment.Create(Geometry.Circle.Create(path_frame, radius)))
    solid = Modeler.Body.SweepProfile(
        Geometry.Profile(Geometry.Plane.Create(frame), boundary), path)
    return DesignBody.Create(part, "Indenter", solid)


def create_geometry():
    positive(tip_radius_um, "tip_radius_um")
    positive(indenter_height_um, "indenter_height_um")
    positive(sample_radius_um, "sample_radius_um")
    positive(substrate_thickness_um, "substrate_thickness_um")
    if not 0 < cone_half_angle_deg < 90:
        raise ValueError("cone_half_angle_deg must be between 0 and 90 degrees")
    if not 1 <= len(layers) <= 3:
        raise ValueError("Specify one to three coatings")
    for material, thickness in layers:
        if not isinstance(material, str) or not re.match(r"^[A-Za-z0-9_]+\Z", material):
            raise ValueError("Coating names must contain only letters, digits and underscores")
        positive(thickness, "coating thickness")
    if indenter_height_um <= tip_radius_um * (1 - math.sin(math.radians(cone_half_angle_deg))):
        raise ValueError("Indenter height must extend beyond the spherical cap")

    part = GetRootPart()
    if len(part.Bodies) or len(part.Components):
        raise ValueError("Run this script in a new, empty document")
    um = 1e-6
    z = 0.0
    for index, (material, thickness) in enumerate(layers, 1):
        cylinder(part, "Layer_{}_{}".format(index, material),
                 sample_radius_um * um, thickness * um, z)
        z -= thickness * um
    cylinder(part, "Substrate_Silicon", sample_radius_um * um,
             substrate_thickness_um * um, z)
    rounded_cone(part, tip_radius_um * um,
                 math.radians(cone_half_angle_deg), indenter_height_um * um)
    ViewHelper.ActivateNamedView("Isometric", True)
    ViewHelper.ZoomToEntity(Selection.Create(part.Bodies))
    print("Created {} coating(s), substrate and indenter. Save the document.".format(len(layers)))


create_geometry()
