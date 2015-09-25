%% Copyright 2014 MERCIER David
function get_param_GUI
%% Function to get values of different variables from the GUI
gui = guidata(gcf);

check_param_GUI;

%% Getting parameters from the GUI
% Substrat
gui.data.Es  = str2double(get(gui.handles.value_youngsub_GUI, 'String')) * 1e9;    %GPa
gui.data.nus = str2double(get(gui.handles.value_poisssub_GUI, 'String'));
gui.data.Hs  = str2double(get(gui.handles.value_hardsub_GUI, 'String'));

% Film 0
gui.data.t0   = str2double(get(gui.handles.value_thickfilm0_GUI,  'String'));       % nm
gui.data.E0   = str2double(get(gui.handles.value_youngfilm0_GUI, 'String')) * 1e9; % GPa
gui.data.nuf0 = str2double(get(gui.handles.value_poissfilm0_GUI, 'String'));
gui.data.Hf0  = str2double(get(gui.handles.value_hardfilm0_GUI, 'String'));

% Film 1
gui.data.t1   = str2double(get(gui.handles.value_thickfilm1_GUI,  'String'));       % nm
gui.data.E1   = str2double(get(gui.handles.value_youngfilm1_GUI, 'String')) * 1e9; % GPa
gui.data.nuf1 = str2double(get(gui.handles.value_poissfilm1_GUI, 'String'));
gui.data.Hf1  = str2double(get(gui.handles.value_hardfilm1_GUI, 'String'));

% Film 2
gui.data.t2   = str2double(get(gui.handles.value_thickfilm2_GUI,  'String'));       % nm
gui.data.E2   = str2double(get(gui.handles.value_youngfilm2_GUI, 'String')) * 1e9; % GPa
gui.data.nuf2 = str2double(get(gui.handles.value_poissfilm2_GUI, 'String'));
gui.data.Hf2  = str2double(get(gui.handles.value_hardfilm2_GUI, 'String'));

% Indenter properties
list_indenters = get(gui.handles.value_indentertype_GUI, 'String');
num_indenters  = get(gui.handles.value_indentertype_GUI, 'Value');
indenter_id    = list_indenters(num_indenters, :);
[val0_str]     = indenter_id{:};

if strcmp(val0_str(1:4), 'Berk') == 1
    gui.variables.val0 = 1;
elseif strcmp(val0_str(1:4), 'Vick') == 1
    gui.variables.val0 = 2;
elseif strcmp(val0_str(1:4), 'Cub') == 1
    gui.variables.val0 = 3;
elseif strcmp(val0_str(1:4), 'Coni') == 1
    gui.variables.val0 = 4;
end

gui.data.indenter_tip_defect = ...
    get(gui.handles.value_indenter_def_prop_GUI, 'String'); % in nm

gui.data.indenter_tip_angle = ...
    get(gui.handles.value_indenter_ang_prop_GUI, 'String'); % in degrees

func_area = getfield(gui.config.indenter, {1}, indenter_id{':'}, {':'});
func_area = cell2mat(func_area(:));
gui.data.C0 = str2double(get(gui.handles.value_C0_GUI, 'String'));
gui.data.C1 = func_area(1);
gui.data.C2 = func_area(2);
gui.data.C3 = func_area(3);
gui.data.C4 = func_area(4);
gui.data.C5 = func_area(5);
gui.data.C6 = func_area(6);
gui.data.C7 = func_area(7);
gui.data.C8 = func_area(8);

% Model properties
gui.variables.num_thinfilm = get(gui.handles.value_numthinfilm_GUI, 'Value');
gui.variables.num_thinfilm_old = gui.variables.num_thinfilm;
gui.variables.King_correction = get(gui.handles.popup_corr_King_GUI, 'Value');
gui.variables.val1 = get(gui.handles.value_modeldisp_GUI, 'Value');
gui.variables.val2 = get(gui.handles.value_model_GUI, 'Value');
gui.variables.val3 = get(gui.handles.value_models_Saha_GUI, 'Value');
gui.variables.thickness_correctionFactor = ...
    str2double(get(gui.handles.value_neta_corr_thickness_GUI, 'String'));

% Plot properties
gui.variables.x_axis = get(gui.handles.value_param2plotinxaxis_GUI, 'Value');
gui.variables.y_axis = get(gui.handles.value_param2plotinyaxis_GUI, 'Value');
gui.variables.y_axis_old = gui.variables.y_axis;

%% Wrong inputs
% Poisson's ratio
if gui.data.nuf0 < -1 || gui.data.nuf0 > 0.5 
    set(gui.handles.value_poissfilm0_GUI, 'String', 0.3);
    warning('Wrong input for Poisson''s ratio !');
end
    
if gui.data.nuf1 < -1 || gui.data.nuf1 > 0.5 
    set(gui.handles.value_poissfilm1_GUI, 'String', 0.3);
    warning('Wrong input for Poisson''s ratio !');
end

if gui.data.nuf2 < -1 || gui.data.nuf2 > 0.5 
    set(gui.handles.value_poissfilm2_GUI, 'String', 0.3);
    warning('Wrong input for Poisson''s ratio !');
end

if gui.data.nus < -1 || gui.data.nus > 0.5 
    set(gui.handles.value_poisssub_GUI, 'String', 0.3);
    warning('Wrong input for Poisson''s ratio !');
end

% Young's modulus
if gui.data.Es < 0
    set(gui.handles.value_youngsub_GUI, 'String', 165); % in GPa
    warning('Wrong input for Young''s modulus !');
end

if gui.data.E0 < 0
    set(gui.handles.value_youngfilm0_GUI, 'String', 100); % in GPa
    warning('Wrong input for Young''s modulus !');
end

if gui.data.E1 < 0
    set(gui.handles.value_youngfilm1_GUI, 'String', 100); % in GPa
    warning('Wrong input for Young''s modulus !');
end 
    
if gui.data.E2 < 0
    set(gui.handles.value_youngfilm2_GUI, 'String', 100); % in GPa
    warning('Wrong input for Young''s modulus !');
end

% Hardness
if gui.data.Hs < 0
    set(gui.handles.value_youngsub_GUI, 'String', 10); % in GPa
    warning('Wrong input for Hardness !');
end 

if gui.data.Hf0 < 0
    set(gui.handles.value_youngfilm0_GUI, 'String', 10); % in GPa
    warning('Wrong input for Hardness !');
end

if gui.data.Hf1 < 0
    set(gui.handles.value_youngfilm1_GUI, 'String', 10); % in GPa
    warning('Wrong input for Hardness !');
end 
    
if gui.data.Hf2 < 0
    set(gui.handles.value_youngfilm2_GUI, 'String', 10); % in GPa
    warning('Wrong input for Hardness !');
end

% Film thickness
if gui.data.t0 < 0
    set(gui.handles.value_thickfilm0_GUI, 'String', 500); % in nm
    warning('Wrong input for film''s thickness !');
end

if gui.data.t1 < 0
    set(gui.handles.value_thickfilm1_GUI, 'String', 500); % in nm
    warning('Wrong input for film''s thickness !');
end 
    
if gui.data.t2 < 0
    set(gui.handles.value_thickfilm2_GUI, 'String', 500); % in nm
    warning('Wrong input for film''s thickness !');
end

% Film thickness correction
if gui.variables.thickness_correctionFactor < gui.config.numerics.thicknessCorrection_low || ...
        gui.variables.thickness_correctionFactor > gui.config.numerics.thicknessCorrection_high
    set(gui.handles.value_neta_corr_thickness_GUI, 'String', ...
        num2str(gui.config.numerics.thicknessCorrection_low));
    warning('Wrong input for film''s thickness correction factor !');
end

guidata(gcf, gui);

end