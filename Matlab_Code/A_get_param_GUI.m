%% Copyright 2014 MERCIER David
function A_get_param_GUI
%% Function to get values of different variables from the GUI
gui = guidata(gcf);

%% Initialization
% if gui.flag.flag_data == 0
%     errordlg('No data !!!', 'No data !!!');

%else
%% Getting parameters from the GUI
% Film 0
gui.data.t0   = str2double (get(gui.handles.value_thinfilm0_GUI,  'String'));       % nm
gui.data.E0   = str2double (get(gui.handles.value_youngfilm0_GUI, 'String')) * 1e9; % GPa
gui.data.nuf0 = str2double (get(gui.handles.value_poissfilm0_GUI, 'String'));

% Film 1
gui.data.t1   = str2double (get(gui.handles.value_thinfilm1_GUI,  'String'));       % nm
gui.data.E1   = str2double (get(gui.handles.value_youngfilm1_GUI, 'String')) * 1e9; % GPa
gui.data.nuf1 = str2double (get(gui.handles.value_poissfilm1_GUI, 'String'));

% Film 2
gui.data.t2   = str2double (get(gui.handles.value_thinfilm2_GUI,  'String'));       % nm
gui.data.E2   = str2double (get(gui.handles.value_youngfilm2_GUI, 'String')) * 1e9; % GPa
gui.data.nuf2 = str2double (get(gui.handles.value_poissfilm2_GUI, 'String'));

% Substrat
gui.data.Es  = str2double (get(gui.handles.value_youngsub_GUI, 'String')) * 1e9;    %GPa
gui.data.nus = str2double (get(gui.handles.value_poisssub_GUI, 'String'));

% Indenter properties
list_indenters = get(gui.handles.value_indentertype_GUI, 'String');
num_indenters  = get(gui.handles.value_indentertype_GUI, 'Value');
indenter_id    = list_indenters(num_indenters, :);
[val0_str]     = indenter_id{:};

if strcmp(val0_str(1:4), 'Berk') == 1
    gui.variables.val0 = 1;
    
elseif strcmp(val0_str(1:4), 'Vick') == 1
    gui.variables.val0 = 2;
    
elseif strcmp(val0_str(1:4), 'Coni') == 1
    gui.variables.val0 = 3;
    
end

gui.data.h_Berk = str2double (get(gui.handles.value_indenterberk_prop_GUI,    'String')); % nm
gui.data.h_Vick = str2double (get(gui.handles.value_indentervickers_prop_GUI, 'String')); % nm
gui.data.h_Coni = str2double (get(gui.handles.value_indentercon_def_prop_GUI, 'String')); % nm
gui.data.C1 = str2double(get(gui.handles.value_C1_GUI, 'String')); % C1=24.56 for Berkovich and C1=24.506 for Vickers
gui.data.C2 = str2double(get(gui.handles.value_C2_GUI, 'String'));
gui.data.C3 = str2double(get(gui.handles.value_C3_GUI, 'String'));
gui.data.C4 = str2double(get(gui.handles.value_C4_GUI, 'String'));
gui.data.C5 = str2double(get(gui.handles.value_C5_GUI, 'String'));
%gui.variables.R = str2double(get(gui.handles.value_indentercon_rad_prop_GUI, 'String')); % µm
gui.data.Ang = str2double(get(gui.handles.value_indentercon_ang_prop_GUI, 'String')); % µm

% Model properties
gui.variables.num_thinfilm = get(gui.handles.value_numthinfilm_GUI,     'Value');
gui.variables.param_corr   = get(gui.handles.value_corrparam_GUI,       'Value');
gui.variables.val1         = get(gui.handles.value_modeldisp_GUI,       'Value');
gui.variables.val2         = get(gui.handles.value_bilayermodel_GUI,    'Value');
gui.variables.val2_mm      = get(gui.handles.value_multilayermodel_GUI, 'Value');

% Plot properties
gui.variables.x_axis = get(gui.handles.value_param2plotinxaxis_GUI, 'Value');
gui.variables.y_axis = get(gui.handles.value_param2plotinyaxis_GUI, 'Value');

%% Error message for inputs
if gui.data.nuf0 < -1 || gui.data.nuf0 > 0.5 || gui.data.nuf1 <- 1 || gui.data.nuf1 > 0.5 || gui.data.nuf2 < -1 || gui.data.nuf2 > 0.5 || gui.data.nus < -1 || gui.data.nus > 0.5
    set(gui.handles.value_poissfilm0_GUI, 'String', 0.3);
    set(gui.handles.value_poissfilm1_GUI, 'String', 0.3);
    set(gui.handles.value_poissfilm2_GUI, 'String', 0.3);
    set(gui.handles.value_poisssub_GUI,   'String', 0.18);
    errordlg('Wrong input for Poisson''s ratio !', 'Input Error');
    %error('Wrong input for Poisson''s ratio !', 'Input Error');
    return;
    
elseif gui.data.E0 < 0 || gui.data.E1 < 0 || gui.data.E2 < 0 || gui.data.Es < 0
    set(gui.handles.value_youngfilm0_GUI, 'String', 100); % in GPa
    set(gui.handles.value_youngfilm1_GUI, 'String', 100); % in GPa
    set(gui.handles.value_youngfilm2_GUI, 'String', 100); % in GPa
    set(gui.handles.value_youngsub_GUI,   'String', 165); % in GPa
    errordlg('Wrong input for Young''s modulus !', 'Input Error');
    %error('Wrong input for Young''s modulus !', 'Input Error');
    return;
    
elseif gui.data.t0 < 0 || gui.data.t1 < 0 || gui.data.t2 < 0
    set(gui.handles.value_thinfilm0_GUI, 'String', 500); % in nm
    set(gui.handles.value_thinfilm1_GUI, 'String', 500); % in nm
    set(gui.handles.value_thinfilm2_GUI, 'String', 500); % in nm
    errordlg('Wrong input for film''s thickness !', 'Input Error');
    %error('Wrong input for film''s thickness !', 'Input Error');
    return;
    
end

%end

guidata(gcf, gui);

end