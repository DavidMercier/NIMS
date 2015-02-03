%% Copyright 2014 MERCIER David
function set_GUI
%% Definition of the GUI and buttons

g = guidata(gcf);

%% Main Window Coordinates Configuration
scrsize = get(0, 'ScreenSize'); % Get screen size
WX = 0.05 * scrsize(3); % X Position (bottom)
WY = 0.10 * scrsize(4); % Y Position (left)
WW = 0.90 * scrsize(3); % Width
WH = 0.80 * scrsize(4); % Height

%% Main Window Configuration
g.handles.MainWindows = figure('Name', ...
    (strcat(g.config.name_toolbox, ...
    ' - Version_', g.config.version_toolbox)),...
    'NumberTitle', 'off',...
    'Color', [0.9 0.9 0.9],...
    'toolBar', 'figure',...
    'PaperPosition', [0 7 50 15],...
    'Color', [0.906 0.906 0.906],...
    'Position', [WX WY WW WH]);

%% Title of the GUI
g.handles.title_GUI_1 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.31 0.96 0.6 0.04],...
    'String', ['Extraction of mechanical properties of thin film(s) ',...
    'on substrate by conical nanoindentation.'],...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red');

g.handles.title_GUI_2 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.31 0.93 0.6 0.03],...
    'String', strcat('Version_', ...
    g.config.version_toolbox, ' - Copyright 2014 MERCIER David'),...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red');

%% Date / Time
g.handles.date_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'String', datestr(datenum(clock),'mmm.dd,yyyy HH:MM'),...
    'Position', [0.92 0.975 0.075 0.02]);

%% Buttons to browse in files
g.handles.opendata_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.018 0.95 0.06 0.04],...
    'String', 'Select file',...
    'FontSize', 10,...
    'FontWeight','bold',...
    'BackgroundColor', [0.745 0.745 0.745],...
    'Callback', 'openfile');

g.handles.opendata_str_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.079 0.95 0.198 0.04],...
    'String', g.config.data.data_path,...
    'FontSize', 8,...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'left');

g.handles.typedata_GUI1 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.018 0.93 0.22 0.02],...
    'String', 'Units : Load (mN) / Displacement (nm) / Stiffness (N/m)',...
    'HorizontalAlignment', 'center');

g.handles.typedata_GUI2 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.018 0.91 0.22 0.02],...
    'String', ['.txt or .xls ==> 3 (or 6) columns : ', ...
    'Displacement / Load / Stiffness'],...
    'HorizontalAlignment', 'center');

g.handles.typedata_GUI3 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.018 0.89 0.22 0.02],...
    'String', ['.xls : XP MTS data with ''Sample''', ...
    'sheet obtained with Analyst'],...
    'HorizontalAlignment', 'center');

%% Definition of the minimum/maximum depth
g.handles.title_mindepth_prop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.86 0.07 0.02],...
    'String', 'Minimum depth :',...
    'HorizontalAlignment', 'left');

g.handles.value_mindepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.08 0.86 0.03 0.02],...
    'String', '',...
    'Callback', 'get_and_plot');

g.handles.unit_mindepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.11 0.86 0.02 0.02],...
    'String', 'nm',...
    'HorizontalAlignment', 'center');

g.handles.title_maxdepth_prop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.84 0.07 0.02],...
    'String', 'Maximum depth :',...
    'HorizontalAlignment', 'left');

g.handles.value_maxdepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.08 0.84 0.03 0.02],...
    'String', '',...
    'Callback', 'get_and_plot');

g.handles.unit_maxdepth_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.11 0.84 0.02 0.02],...
    'String', 'nm',...
    'HorizontalAlignment', 'center');

%% CSM corrections
g.handles.cb_CSM_corr_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.02 0.81 0.2 0.02],...
    'String', 'CSM_correction (only valide for Berkovich indenters)',...
    'Value', 0,...
    'Callback', 'get_and_plot');

%% Choice of the indenter (only conical indenters...)
g.handles.title_indentertype_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.77 0.1 0.02],...
    'String', 'Type of indenter',...
    'HorizontalAlignment', 'left');

g.handles.value_indentertype_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.75 0.1 0.02],...
    'String', g.config.indenter.Indenter_IDs,...
    'Value', 1,...
    'Callback', 'refresh_indenters_GUI');

set(g.handles.value_indentertype_GUI, 'value', ...
    find(cell2mat(strfind(g.config.indenter.Indenter_IDs, ...
    g.config.indenter.Indenter_ID))));

% Indenter tip - Creation of button group
g.handles.bg_indenter_tip_GUI = uibuttongroup('Parent', gcf,...
    'Position', [0.02 0.64 0.255 0.1]);

guidata(gcf, g);

% Set properties of indenter
indenters_properties_GUI;

%% Encapsulation of data into the GUI
g = guidata(gcf); guidata(gcf, g);

%% Choice of the material indenter
g.handles.title_indentermaterial_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.14 0.77 0.1 0.02],...
    'String', 'Material of indenter',...
    'HorizontalAlignment', 'left');

g.handles.value_indentermaterial_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.14 0.75 0.1 0.02],...
    'String', g.config.indenter.Indenter_materials,...
    'Value', 1,...
    'Callback', 'refresh_indenters_GUI');

set(g.handles.value_indentermaterial_GUI, 'value', ...
    find(cell2mat(strfind(g.config.indenter.Indenter_materials, ...
    g.config.indenter.Indenter_material))));

guidata(gcf, g);

%% Encapsulation of data into the GUI
g = guidata(gcf); guidata(gcf, g);

%% Properties of the sample
% Number of thin films
g.handles.title_numthinfilm_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.61 0.1 0.02],...
    'String', 'Number of thin films',...
    'HorizontalAlignment', 'left');

g.handles.value_numthinfilm_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.59 0.1 0.02],...
    'String', '0|1|2|3',...
    'Value', 4,...
    'Callback', 'refresh_indenters_GUI');

% Creation of button groups
g.handles.bg_film2_properties_GUI = uibuttongroup(...
    'Parent', g.handles.MainWindows, ...
    'Position', [0.02 0.5425 0.255 0.0375]);
g.handles.bg_film1_properties_GUI = uibuttongroup(...
    'Parent', g.handles.MainWindows, ...
    'Position', [0.02 0.5050 0.255 0.0375]);
g.handles.bg_film0_properties_GUI = uibuttongroup(...
    'Parent', g.handles.MainWindows, ...
    'Position', [0.02 0.4675 0.255 0.0375]);
g.handles.bg_substrat_properties_GUI = uibuttongroup(...
    'Parent', g.handles.MainWindows, ...
    'Position', [0.02 0.4100 0.255 0.0575]);

%% Convention
g.handles.plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.14 0.59 0.08 0.03],...
    'String', 'Convention',...
    'FontSize', 12,...
    'BackgroundColor', [0.745 0.745 0.745],...
    'Callback', 'figure; imshow(''convention_multilayer.png'');');

%% Choice of the model for contact displacement calculation
g.handles.title_modeldisp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.38 0.1 0.02],...
    'String', 'Model for contact displacement calculation',...
    'HorizontalAlignment', 'left');

g.handles.value_modeldisp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.36 0.1 0.02],...
    'String', 'Doerner&Nix|Oliver&Pharr|Loubet',...
    'Value', 2,...
    'Callback', 'get_and_plot');

%% Correction parameters
g.handles.title_corr_King_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.13 0.38 0.1 0.02],...
    'String', 'Correction to apply',...
    'HorizontalAlignment', 'left');

g.handles.popup_corr_King_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.13 0.36 0.1 0.02],...
    'String', 'beta King1987|beta Hay1999',...
    'Value', 1,...
    'Callback', 'get_and_plot');

g.handles.cb_corr_thickness_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.13 0.31 0.1 0.02],...
    'String', 't_eff Mencik1997',...
    'Value', 1,...
    'Visible', 'off',...
    'Callback', 'get_and_plot');

%% Choice of the model to fit load-displacement curves
g.handles.title_model_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.33 0.1 0.02],...
    'HorizontalAlignment', 'left');

g.handles.value_model_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.31 0.1 0.02],...
    'Value', 1,...
    'Callback', 'get_and_plot');

%% LoadDisp / Bilayer / Multilayer model
g.handles.title_load_disp_model = 'Load-Disp. Model';

g.handles.list_load_disp_model = {'No_load_Disp_model',...
    'Loubet', ...
    'Hainsworth'};

set(g.handles.title_model_GUI, 'String', g.handles.title_load_disp_model);
set(g.handles.value_model_GUI, 'String', g.handles.list_load_disp_model);

g.handles.title_bilayermodel = 'Bilayer Model (Y''s M calc.)';

g.handles.list_bilayermodel = {'No_Bilayer_Model', ...
    'Doerner&Nix_King',...
    'Gao_etal.',...
    'Bec_etal.',...
    'Hay_etal.',...
    'Perriot_etal.',...
    'Mencik_etal._linear',...
    'Mencik_etal._exponential',...
    'Mencik_etal._reciprocal_exp.'};

g.handles.title_multilayermodel = 'Multilayer Model (Y''s M calc.)';

g.handles.list_multilayermodel = {'No_Multilayer_Model', ...
    'Mercier_etal.'};

%% Parameter to plot
g.handles.title_param2plotinxaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.26 0.1 0.02],...
    'String', 'Parameter to plot ==> x axis',...
    'HorizontalAlignment', 'left');

g.handles.value_param2plotinxaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.02 0.24 0.1 0.02],...
    'String', 'Displ.|Cont.rad./Thick.|Displ./Thick.',...
    'Value', 1,...
    'Callback', 'get_and_plot');

g.handles.title_param2plotinyaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.13 0.26 0.1 0.02],...
    'String', 'Parameter to plot ==> y axis',...
    'HorizontalAlignment', 'left');

g.handles.value_param2plotinyaxis_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.13 0.24 0.1 0.02],...
    'String', {'Load', ...
    'Stiffness', ...
    'Load oved Stiffness squared', ...
    'Red. Young''s modulus(film+sub)', ...
    'Red. Young''s modulus(film)', ...
    'Hardness'},...
    'Value', 1,...
    'Callback', 'get_and_plot');

%% Options of the plot
g.handles.cb_log_plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.02 0.19 0.05 0.03],...
    'String', 'Log',...
    'Value', 0,...
    'Callback', 'get_and_plot');

g.handles.cb_grid_plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', [0.07 0.19 0.05 0.03],...
    'String', 'Grid',...
    'Value', 1,...
    'Callback', 'get_and_plot');

g.handles.pb_residual_plot_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.13 0.19 0.1 0.03],...
    'String', 'Residuals',...
    'Visible', 'off',...
    'Value', 0,...
    'Callback', 'plot_selection(2)');

%% Plot configuration
g.handles.AxisPlot_GUI = axes('Parent', gcf,...
    'Position', [0.33 0.1 0.65 0.75]);

set(g.handles.MainWindows,'CurrentAxes', g.handles.AxisPlot_GUI);

%% Get values from plot
g.handles.cb_get_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.02 0.15 0.1 0.03],...
    'String', 'Get x and y values',...
    'Callback', 'plot_get_values');

g.handles.title_x_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.13 0.03 0.02],...
    'String', 'X value :',...
    'HorizontalAlignment', 'left');

g.handles.value_x_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.05 0.13 0.03 0.02],...
    'String', '');

g.handles.title_y_values_prop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.11 0.03 0.02],...
    'String', 'Y value :',...
    'HorizontalAlignment', 'left');

g.handles.value_y_values_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.05 0.11 0.03 0.02],...
    'String', '');

%% Others buttons
% Python for FEM (Abaqus)
g.handles.python4fem = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.13 0.12 0.1 0.05],...
    'String', 'FEM',...
    'Callback', 'python4abaqus');

% Save
g.handles.save_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.13 0.05 0.1 0.05],...
    'String', 'SAVE',...
    'Callback', 'export_data_to_YAML_file');

% Quit
g.handles.quit_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.02 0.05 0.1 0.05],...
    'String', 'QUIT',...
    'Callback', 'close(gcf);clear all');

set([g.handles.python4fem, g.handles.save_GUI, g.handles.quit_GUI],...
    'FontSize', 12,...
    'BackgroundColor', [0.745 0.745 0.745]);

guidata(gcf, g);

end