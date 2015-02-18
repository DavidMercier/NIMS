%% Copyright 2014 MERCIER David
function python4abaqus
%% Function to generate a Python script for Abaqus (FEM model)

get_param_GUI;
gui = guidata(gcf); guidata(gcf);

if gui.flag.flag_data ~= 0
    FILENAME = gui.data.filename_data;
    PATHNAME = gui.data.pathname_data;
else
    %scriptpath_multilayer_model = uigetdir(pwd, 'Pick a Directory to save FEM model');
    [FILENAME, PATHNAME, FILTERINDEX] = uiputfile(...
        '*.py', 'Select a directory to save FEM model as a *.py file');
    if isequal(FILENAME, 0)
        FILENAME = strcat(datestr(datenum(clock),'yyyy_mm_dd'), ...
            '_userdata_abaqus_fem_model');
    end
end

scriptpath_multilayer_model = PATHNAME;
scriptname_multilayer_model = strtok(FILENAME, '.');

if ~isempty(scriptpath_multilayer_model)
    
    if isunix()
        username_str = getenv('USER');
    else
        username_str = getenv('username');
    end
    
    % Dimensions are in nm and Young's moduli are in GPa. Load is in nN.
    
    gui.variables.num_thinfilm; % 1 (when only substrate) to 4 (substrate + 3 films)
    E = [gui.data.Es, gui.data.E0, gui.data.E1, gui.data.E2];
    nu = [gui.data.nus, gui.data.nuf0, gui.data.nuf1, gui.data.nuf2];
    t_sub = 2 * max([gui.data.t0, gui.data.t1, gui.data.t2]);
    t_f = [gui.data.t2, gui.data.t1, gui.data.t0, t_sub];
    
    if str2num(gui.data.indenter_tip_defect) == 0
        indenter_tip_defect = 0.1;
    else
        indenter_tip_defect = str2num(gui.data.indenter_tip_defect);
    end
    
    if indenter_tip_defect > t_sub + t_sub/2
        wid = 2 * indenter_tip_defect;
        abaqus_sketch_sheet_size = 3 * indenter_tip_defect;
    else
        wid = 2 * (t_sub + t_sub/2);
        abaqus_sketch_sheet_size = 3 * (t_sub + t_sub/2);
    end
    
    % Definition of spherical part
    % See Mesa B. "Spherical and rounded cone nano indenters" Micro Star Technologies
    a_ind = str2num(gui.data.indenter_tip_angle);
    r_ind = indenter_tip_defect / ((1/(sind(a_ind)))-1);
    y_trans = r_ind * (1 - sind(a_ind));
    x_trans = (((r_ind)^2)-((r_ind - y_trans)^2))^0.5;
    
    % Definition of conical part
    d_con_part = wid/2;
    x_con_part = d_con_part * cosd(90 - a_ind);
    y_con_part = d_con_part * sind(90 - a_ind);
    
    % Definition of mesh variables
    k_min = wid/min(t_f(:));
    n_elem_y_min = 20; % 20 elements in the thickness of the thinnest film
    n_elem_x_min = round(n_elem_y_min * k_min);
    x_min_elem = min(t_f(:)) / n_elem_y_min;
    for ii = 1:length(t_f)
        k(ii) = wid/t_f(ii);
        n_elem_y(ii) = t_f(ii) / x_min_elem;
        n_elem_x(ii) = round(n_elem_x_min);
    end
    
    % Definition of elements type
    linear_elements = 0; % 0 for quadratic elements and 1 for linear elements
    
    % Definition of indentation displacement
    ind_disp = -200;
    
    py{1}     = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# Python script for use with Abaqus 6.12');
    py{end+1} = sprintf('#====================================================================================================================');
    py{end+1} = sprintf('# AUTHOR: %s', username_str);
    py{end+1} = sprintf('# DATE: %s', datestr(datenum(clock),'mmm.dd,yyyy HH:MM'));
    py{end+1} = sprintf('# GENERATED WITH: %s written by D. Mercier', strcat(gui.config.name_toolbox, '_', gui.config.version_toolbox));
    py{end+1} = sprintf('# See https://github.com/DavidMercier/nanoind-data-analysis');
    py{end+1} = sprintf('# or http://www.mathworks.fr/matlabcentral/fileexchange/43392-toolbox-to-analyze-nanoindentation-data');
    py{end+1} = sprintf('# Modelling of indentation experiments with a (sphero-)conical indenter performed on a multilayer system');
    py{end+1} = sprintf('# To run this procedure Python script, open Abaqus, then ==> File/Run Script');
    py{end+1} = sprintf('# Units: Displacement in nm, Young''s modulus in GPa ==> Load in nN.');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# NEW MODEL');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('from abaqus import *');
    py{end+1} = sprintf('from abaqusConstants import *');
    py{end+1} = sprintf('from caeModules import *');
    py{end+1} = sprintf('from driverUtils import executeOnCaeStartup');
    py{end+1} = sprintf('');
    py{end+1} = sprintf('import section');
    py{end+1} = sprintf('import regionToolset');
    py{end+1} = sprintf('import displayGroupMdbToolset as dgm');
    py{end+1} = sprintf('import part');
    py{end+1} = sprintf('import material');
    py{end+1} = sprintf('import assembly');
    py{end+1} = sprintf('import step');
    py{end+1} = sprintf('import interaction');
    py{end+1} = sprintf('import load');
    py{end+1} = sprintf('import mesh');
    py{end+1} = sprintf('if (''12'' in version) == True:');
    py{end+1} = sprintf('    import optimization # Not available in versions released before Abaqus 6.12');
    py{end+1} = sprintf('import job');
    py{end+1} = sprintf('import sketch');
    py{end+1} = sprintf('import visualization');
    py{end+1} = sprintf('import xyPlot');
    py{end+1} = sprintf('import displayGroupOdbToolset as dgo');
    py{end+1} = sprintf('import connectorBehavior');
    py{end+1} = sprintf('');
    py{end+1} = sprintf('cliCommand("""session.journalOptions.setValues(replayGeometry=COORDINATE, recoverGeometry=COORDINATE)""")');
    py{end+1} = sprintf('backwardCompatibility.setValues(includeDeprecated=True, reportDeprecated=False)');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# PARAMETERS');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('myModel = mdb.Model(name=''%s'')', strcat('multilayer_model_', datestr(datenum(clock),'yyyy-mm-dd')));
    py{end+1} = sprintf('indenter_used = ''%s''', gui.config.indenter.Indenter_ID);
    py{end+1} = sprintf('h_ind = %f', indenter_tip_defect);
    py{end+1} = sprintf('r_ind = %f', r_ind);
    py{end+1} = sprintf('a_ind = %s', gui.data.indenter_tip_angle);
    py{end+1} = sprintf('sheet_Size = %f', abaqus_sketch_sheet_size);
    py{end+1} = sprintf('step_Load = ''Loading''');
    py{end+1} = sprintf('ind_h = %f', ind_disp);
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# PARTS');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# Analytical rigid indenter');
    py{end+1} = sprintf('s = myModel.ConstrainedSketch(name=''__profile__'', sheetSize=sheet_Size)');
    py{end+1} = sprintf('g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints');
    py{end+1} = sprintf('s.sketchOptions.setValues(viewStyle=AXISYM)');
    py{end+1} = sprintf('s.setPrimaryObject(option=STANDALONE)');
    py{end+1} = sprintf('s.ConstructionLine(point1=(0.0, -100.0), point2=(0.0, 100.0))');
    py{end+1} = sprintf('s.FixedConstraint(entity=g[2])');
    py{end+1} = sprintf('s.ArcByCenterEnds(center=(0.0, r_ind), point1=(%f , %f), point2=(0.0, 0.0),direction=CLOCKWISE)', x_trans, y_trans);
    py{end+1} = sprintf('s.Line(point1=(%f , %f), point2=(%f , %f))', x_trans, y_trans, x_trans + x_con_part, y_trans + y_con_part);
    py{end+1} = sprintf('s.TangentConstraint(entity1=g[3], entity2=g[4])');
    py{end+1} = sprintf('p = myModel.Part(name=indenter_used, dimensionality=AXISYMMETRIC, type=ANALYTIC_RIGID_SURFACE)');
    py{end+1} = sprintf('p = myModel.parts[indenter_used]');
    py{end+1} = sprintf('p.AnalyticRigidSurf2DPlanar(sketch=s)');
    py{end+1} = sprintf('s.unsetPrimaryObject()');
    py{end+1} = sprintf('p = myModel.parts[indenter_used]');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].setValues(displayedObject=p)');
    py{end+1} = sprintf('del myModel.sketches[''__profile__'']');
    py{end+1} = sprintf('p = myModel.parts[indenter_used]');
    py{end+1} = sprintf('v1, e, d1, n = p.vertices, p.edges, p.datums, p.nodes');
    py{end+1} = sprintf('p.ReferencePoint(point=v1.findAt(coordinates=(0.0, 0.0, 0.0)))');
    py{end+1} = sprintf('# -------------------------------------------------------------------------------------------------------------------');
    py{end+1} = sprintf('# Multilayer sample');
    t_ori = 0;
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('s = myModel.ConstrainedSketch(name=''__profile__'', sheetSize=sheet_Size)');
        py{end+1} = sprintf('g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints');
        py{end+1} = sprintf('s.sketchOptions.setValues(viewStyle=AXISYM)');
        py{end+1} = sprintf('s.setPrimaryObject(option=STANDALONE)');
        py{end+1} = sprintf('s.ConstructionLine(point1=(0.0, -100.0), point2=(0.0, 100.0))');
        py{end+1} = sprintf('s.FixedConstraint(entity=g[2])');
        py{end+1} = sprintf('s.rectangle(point1=(0.0, %f), point2=(%f, %f))', t_ori, wid, t_ori-t_f(ii));
        py{end+1} = sprintf('s.CoincidentConstraint(entity1=v[0], entity2=g[2], addUndoState=False)');
        py{end+1} = sprintf('p = myModel.Part(name=''%s'', dimensionality=AXISYMMETRIC, type=DEFORMABLE_BODY)', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('p = myModel.parts[''%s'']', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('p.BaseShell(sketch=s)');
        py{end+1} = sprintf('s.unsetPrimaryObject()');
        py{end+1} = sprintf('p = myModel.parts[''%s'']', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('session.viewports[''Viewport: 1''].setValues(displayedObject=p)');
        py{end+1} = sprintf('del myModel.sketches[''__profile__'']');
        t_ori = t_ori - t_f(ii);
    end
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# MATERIALS');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('myModel.Material(name=''%s'')', char(gui.data.indenter_material));
    py{end+1} = sprintf('myModel.materials[''%s''].Density(table=((1.0, ), ))',char(gui.data.indenter_material));
    py{end+1} = sprintf('myModel.materials[''%s''].Elastic(temperatureDependency=False,table=((%f, %f), ))',...
        char(gui.data.indenter_material), gui.data.indenter_material_ym, gui.data.indenter_material_pr);
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('myModel.Material(name=''%s'')', strcat('Material_', num2str(ii)));
        py{end+1} = sprintf('myModel.materials[''%s''].Density(table=((1.0, ), ))',strcat('Material_', num2str(ii)));
        py{end+1} = sprintf('myModel.materials[''%s''].Elastic(temperatureDependency=False,table=((%f, %f), ))',...
            strcat('Material_', num2str(ii)), E(ii)/1e9, nu(ii));
    end
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# SECTIONS');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('mySection = myModel.HomogeneousSolidSection(name=''%s'',material=''%s'')', 'Section_indenter', char(gui.data.indenter_material));
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('mySection = myModel.HomogeneousSolidSection(name=''%s'',material=''%s'')',...
            strcat('Section_material_', num2str(ii)), strcat('Material_', num2str(ii)));
    end
    py{end+1} = sprintf('myModel.rootAssembly.regenerate()');
    t_ori = 0;
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('p = myModel.parts[''%s'']', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('session.viewports[''Viewport: 1''].setValues(displayedObject=p)');
        py{end+1} = sprintf('p = myModel.parts[''%s'']', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('f = p.faces');
        py{end+1} = sprintf('faces = f.findAt(((%f, %f, 0.0), ))', wid/2, t_ori - t_f(ii)/2);
        py{end+1} = sprintf('region = p.Set(faces=faces, name=''%s'')', strcat('Set_', num2str(ii)));
        py{end+1} = sprintf('p = myModel.parts[''%s'']', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('p.SectionAssignment(region=region, sectionName=''%s'', offset=0.0, offsetType=MIDDLE_SURFACE, offsetField='''', thicknessAssignment=FROM_SECTION)',...
            strcat('Section_material_', num2str(ii)));
        t_ori = t_ori - t_f(ii);
    end
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# ASSEMBLY');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('myAssembly = myModel.rootAssembly');
        py{end+1} = sprintf('p = myModel.parts[''%s'']', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('myAssembly.Instance(name=''%s'', part=p, dependent=OFF)',...
            strcat('Film_', num2str(ii)));
    end
    py{end+1} = sprintf('myAssembly = myModel.rootAssembly');
    py{end+1} = sprintf('p = myModel.parts[indenter_used]');
    py{end+1} = sprintf('myAssembly.Instance(name=indenter_used, part=p, dependent=OFF)');
    py{end+1} = sprintf('myAssembly = myModel.rootAssembly');
    py{end+1} = sprintf('myAssembly.regenerate()');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# STEPS');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].setValues(displayedObject=myAssembly)');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.setValues(step=''Initial'')');
    py{end+1} = sprintf('myModel.StaticStep(name=step_Load, previous=''Initial'', description=''Indentation step'', maxNumInc=100000, initialInc=0.0001, minInc=1e-30, maxInc=0.02)');
    py{end+1} = sprintf('myModel.steps[step_Load].setValues(nlgeom=ON)');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.setValues(step=step_Load)');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# MESH');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.setValues(mesh=ON)');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.meshOptions.setValues(meshTechnique=ON)');
    py{end+1} = sprintf('a = myModel.rootAssembly');
    t_ori = 0;
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('e%s = a.instances[''%s''].edges', num2str(ii), strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('pickedEdges = e%s.findAt(((0.0, %f, 0.0), ))', num2str(ii), t_ori-t_f(ii)/2);
        py{end+1} = sprintf('a.seedEdgeByNumber(edges=pickedEdges, number=int(%f), constraint=FINER)', n_elem_y(ii));
        py{end+1} = sprintf('pickedEdges = e%s.findAt(((%f, %f, 0.0), ))', num2str(ii), wid, t_ori-t_f(ii)/2);
        py{end+1} = sprintf('a.seedEdgeByNumber(edges=pickedEdges, number=int(%f), constraint=FINER)', n_elem_y(ii));
        py{end+1} = sprintf('pickedEdges = e%s.findAt(((%f, %f, 0.0), ))', num2str(ii), wid/2, t_ori);
        py{end+1} = sprintf('a.seedEdgeByNumber(edges=pickedEdges, number=int(%f), constraint=FINER)', n_elem_x(ii));
        % code for the bias...
        %py{end+1} = sprintf('a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges, ratio=5.0, number=int(%f), constraint=FINER))', n_elem_x(ii));
        %py{end+1} = sprintf('a.seedEdgeByBias(biasMethod=SINGLE, end2Edges=pickedEdges, ratio=5.0, number=int(%f), constraint=FINER))', n_elem_x(ii));
        %py{end+1} = sprintf('a.seedEdgeByBias(biasMethod=DOUBLE, endEdges=pickedEndEdges, ratio=5.0, number=int(%f), constraint=FINER))', n_elem_x(ii));
        py{end+1} = sprintf('f = a.instances[''%s''].faces', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('pickedRegions = f.findAt(((%f, %f, 0.0), ))', wid/2, t_ori-t_f(ii)/2);
        py{end+1} = sprintf('a.setMeshControls(regions=pickedRegions, elemShape=QUAD_DOMINATED)'); %TRI or QUAD
        t_ori = t_ori-t_f(ii);
    end
    py{end+1} = sprintf('pickedEdges = e%s.findAt(((%f, %f, 0.0), ))', num2str(gui.variables.num_thinfilm), wid/2, t_ori);
    py{end+1} = sprintf('a.seedEdgeByNumber(edges=pickedEdges, number=int(%f), constraint=FINER)', n_elem_x(ii));
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('partInstances =(a.instances[''%s''], )', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('a.generateMesh(regions=partInstances)');
    end
    t_ori = 0;
    if linear_elements == 1
        py{end+1} = sprintf('elemType1 = mesh.ElemType(elemCode=CAX4R, elemLibrary=STANDARD)'); % CAX4R: A 4-node bilinear axisymmetric quadrilateral, reduced integration, hourglass control.
        py{end+1} = sprintf('elemType2 = mesh.ElemType(elemCode=CAX3, elemLibrary=STANDARD)'); % CAX3:  A 3-node linear axisymmetric triangle.
    else
        py{end+1} = sprintf('elemType1 = mesh.ElemType(elemCode=CAX8R, elemLibrary=STANDARD)'); % CAX8R: An 8-node biquadratic axisymmetric quadrilateral, reduced integration.
        py{end+1} = sprintf('elemType2 = mesh.ElemType(elemCode=CAX6M, elemLibrary=STANDARD)'); % CAX6M: A 6-node modified quadratic axisymmetric triangle.
    end
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('f = a.instances[''%s''].faces', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('faces = f.findAt(((%f, %f, 0.0), ))', wid/2, t_ori-t_f(ii)/2);
        py{end+1} = sprintf('pickedRegions =(faces, )');
        py{end+1} = sprintf('a.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2))');
        t_ori = t_ori-t_f(ii);
    end
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# INTERACTIONS');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('myModel.ContactProperty(''%s'')', strcat('Indenter-Film_1'));
    py{end+1} = sprintf('myModel.interactionProperties[''%s''].TangentialBehavior(formulation=FRICTIONLESS)', strcat('Indenter-Film_1'));
    py{end+1} = sprintf('myModel.interactionProperties[''%s''].NormalBehavior(pressureOverclosure=HARD, allowSeparation=OFF, constraintEnforcementMethod=DEFAULT)', strcat('Indenter-Film_1'));
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.setValues(mesh=OFF, interactions=ON, constraints=ON, connectors=ON, engineeringFeatures=ON)');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.meshOptions.setValues(meshTechnique=OFF)');
    py{end+1} = sprintf('a = myModel.rootAssembly');
    py{end+1} = sprintf('s1 = a.instances[indenter_used].edges');
    py{end+1} = sprintf('side2Edges1 = s1.findAt(((%f, %f, 0.0), ))', x_trans, y_trans);
    py{end+1} = sprintf('region1=regionToolset.Region(side2Edges=side2Edges1)');
    py{end+1} = sprintf('a = myModel.rootAssembly');
    py{end+1} = sprintf('s1 = a.instances[''%s''].edges', 'Film_1');
    py{end+1} = sprintf('side1Edges1 = s1.findAt(((%f, 0.0, 0.0), ))', wid/2);
    py{end+1} = sprintf('region2=regionToolset.Region(side1Edges=side1Edges1)');
    py{end+1} = sprintf('myModel.SurfaceToSurfaceContactStd(name=''%s'', createStepName=step_Load, master=region1, slave=region2, sliding=FINITE, thickness=ON, interactionProperty=''%s'', adjustMethod=NONE, initialClearance=OMIT, datumAxis=None, clearanceRegion=None)',...
        strcat('Interaction_Indenter-Film_1'), strcat('Indenter-Film_1'));
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# BOUNDARIES CONDITIONS');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.setValues(loads=ON, bcs=ON, predefinedFields=ON, interactions=OFF, constraints=OFF, connectors=ON, engineeringFeatures=OFF)');
    py{end+1} = sprintf('a = myModel.rootAssembly');
    t_ori = 0;
    for ii = 1:gui.variables.num_thinfilm
        py{end+1} = sprintf('e1 = a.instances[''%s''].edges', strcat('Film_', num2str(ii)));
        py{end+1} = sprintf('edges1 = e1.findAt(((0.0, %f, 0.0), ))', t_ori-t_f(ii)/2);
        py{end+1} = sprintf('region = regionToolset.Region(edges=edges1)');
        py{end+1} = sprintf('myModel.DisplacementBC(name=''%s'', createStepName=step_Load, region=region, u1=0.0, u2=UNSET, ur3=UNSET, amplitude=UNSET, fixed=OFF, distributionType=UNIFORM, fieldName='''', localCsys=None)', ...
            strcat('BC_Film_', num2str(ii)));
        t_ori = t_ori-t_f(ii);
    end
    py{end+1} = sprintf('e1 = a.instances[''%s''].edges', strcat('Film_', num2str(gui.variables.num_thinfilm)));
    py{end+1} = sprintf('edges1 = e1.findAt(((%f, %f, 0.0), ))', wid/2, t_ori);
    py{end+1} = sprintf('region = regionToolset.Region(edges=edges1)');
    py{end+1} = sprintf('myModel.DisplacementBC(name=''%s'', createStepName=step_Load, region=region, u1=0.0, u2=0.0, ur3=UNSET, amplitude=UNSET, fixed=OFF, distributionType=UNIFORM, fieldName='''', localCsys=None)', ...
        strcat('BC_Film_', num2str(ii), '_2'));
    py{end+1} = sprintf('# -------------------------------------------------------------------------------------------------------------------');
    py{end+1} = sprintf('# Indentation displacement');
    py{end+1} = sprintf('r1 = a.instances[indenter_used].referencePoints');
    py{end+1} = sprintf('refPoints1=(r1[2], )');
    py{end+1} = sprintf('region = regionToolset.Region(referencePoints=refPoints1)');
    py{end+1} = sprintf('myModel.DisplacementBC(name=''%s'', createStepName=step_Load, region=region, u1=0.0, u2=ind_h, ur3=UNSET, amplitude=UNSET, fixed=OFF, distributionType=UNIFORM, fieldName='''', localCsys=None)', ...
        'BC_Indentation_step');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('# JOB');
    py{end+1} = sprintf('#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    py{end+1} = sprintf('session.viewports[''Viewport: 1''].assemblyDisplay.setValues(loads=OFF, bcs=OFF, predefinedFields=OFF, connectors=OFF)');
    py{end+1} = sprintf('mdb.Job(name=''Job1'', model=''%s'', description=''Indentation of multilayer sample'', type=ANALYSIS, atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='''', scratch='''', multiprocessingMode=DEFAULT, numCpus=1, numDomains=2)',...
        strcat('multilayer_model_', datestr(datenum(clock),'yyyy-mm-dd')));
    
    cd(scriptpath_multilayer_model);
    fid = fopen([scriptname_multilayer_model, '.py'], 'w+');
    for iln = 1:numel(py)
        fprintf(fid, '%s\n', py{iln});
    end
    fclose(fid);
    commandwindow;
    display('Python script has been generated...');
    
end

end