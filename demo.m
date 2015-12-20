%% Copyright 2014 MERCIER David
function gui_handle = demo
%% Function to run the Matlab GUI for the calculations of elastic-plastic properties
% of a multilayer system from indentation experiments with a conical indenter

%% Check License of Optimization Toolbox
license_msg = ['Sorry, no license found for the Matlab ', ...
    'Optimization Toolbox™ !'];
if  license('checkout', 'Optimization_Toolbox') == 0
    warning(license_msg);
    licenceFlag_1 = 0;
else
    licenceFlag_1 = 1;
end

%% Check License of Image Toolbox
license_msg = ['Sorry, no license found for the Matlab ', ...
    'Image Processing Toolbox™ !'];
if  license('checkout', 'Image_Toolbox') == 0
    warning(license_msg);
    licenceFlag_2 = 0;
else
    licenceFlag_2 = 1;
end

%% Define gui structure variable
gui = struct();
gui.config = struct();
gui.config.indenter = struct();
gui.config.data = struct();
gui.config.numerics = struct();

%% Paths Management
% Don't move before definition of 'gui' as a struct()
try
    gui.config.NIMSroot = get_nims_root; % ensure that environment is set
catch
    [startdir, dummy1, dummy2] = fileparts(mfilename('fullpath'));
    cd(startdir);
    commandwindow;
    path_management;
    gui.config.NIMSroot = get_nims_root; % ensure that environment is set
end

[gui.config.indenter, gui.config.data, ...
    gui.config.numerics, flag_YAML] = load_YAMLconfigFile;

%% Set Toolbox version and help paths
gui.config.name_toolbox = 'NIMS';
gui.config.version_toolbox = '3.2';
gui.config.url_help = 'http://nims.readthedocs.org/en/latest/';
gui.config.pdf_help = 'https://media.readthedocs.org/pdf/nims/latest/nims.pdf';
gui.config.licenceOpt_Flag = licenceFlag_1;
gui.config.licenceIma_Flag = licenceFlag_2;

%% Main Window Coordinates Configuration
scrsize = get(0, 'ScreenSize'); % Get screen size
WX = 0.05 * scrsize(3); % X Position (bottom)
WY = 0.10 * scrsize(4); % Y Position (left)
WW = 0.90 * scrsize(3); % Width
WH = 0.80 * scrsize(4); % Height

gui.MainWindows = figure('Name', ...
    (strcat(gui.config.name_toolbox, ...
    ' - Version_', gui.config.version_toolbox)),...
    'NumberTitle', 'off',...
    'Color', [0.9 0.9 0.9],...
    'toolBar', 'figure',...
    'PaperPosition', [0 7 50 15],...
    'Color', [0.906 0.906 0.906],...
    'Position', [WX WY WW WH]);

guidata(gcf, gui);

%% GUI building
gui.handles = set_GUI;
guidata(gcf, gui);

% Set properties of indenter
indenters_properties_GUI;
gui = guidata(gcf); guidata(gcf, gui);

% YAML and Help menus
customized_menu(gcf);

%% Set flags
gui.flag.flag = 0;
gui.flag.flag_data = 0;
gui.variables.y_axis_old = 1;
gui.variables.num_thinfilm_old = 1;
guidata(gcf, gui);

if flag_YAML
    %% Initialization of indenter properties
    refresh_indenters_GUI(0);
    gui = guidata(gcf); guidata(gcf, gui);
    
    %% Set properties of thin films
    position = [0.01 0.05 0.14 0.7];
    
    % Substrate
    [gui.handles.title_sub_GUI, gui.handles.title_thicksub_GUI, ...
        gui.handles.value_thicksub_GUI, gui.handles.unit_thicksub_GUI, ...
        gui.handles.title_youngsub_GUI, gui.handles.value_youngsub_GUI, ...
        gui.handles.unit_youngsub_GUI, gui.handles.title_poisssub_GUI, ...
        gui.handles.value_poisssub_GUI, gui.handles.title_hardsub_GUI, ...
        gui.handles.value_hardsub_GUI, gui.handles.unit_hardsub_GUI] = ...
        thin_films_properties_GUI(gui.handles.bg_substrat_properties_GUI, ...
        position, 'Substrate :');
    % Film 0
    [gui.handles.title_film0_GUI, gui.handles.title_thickfilm0_GUI, ...
        gui.handles.value_thickfilm0_GUI, gui.handles.unit_thickfilm0_GUI, ...
        gui.handles.title_youngfilm0_GUI, gui.handles.value_youngfilm0_GUI, ...
        gui.handles.unit_youngfilm0_GUI, gui.handles.title_poissfilm0_GUI, ...
        gui.handles.value_poissfilm0_GUI, gui.handles.title_hardfilm0_GUI, ...
        gui.handles.value_hardfilm0_GUI, gui.handles.unit_hardfilm0_GUI] = ...
        thin_films_properties_GUI(gui.handles.bg_film0_properties_GUI, ...
        position, 'Film 0 :');
    % Film 1
    [gui.handles.title_film1_GUI, gui.handles.title_thickfilm1_GUI, ...
        gui.handles.value_thickfilm1_GUI, gui.handles.unit_thickfilm1_GUI, ...
        gui.handles.title_youngfilm1_GUI, gui.handles.value_youngfilm1_GUI, ...
        gui.handles.unit_youngfilm1_GUI, gui.handles.title_poissfilm1_GUI, ...
        gui.handles.value_poissfilm1_GUI, gui.handles.title_hardfilm1_GUI, ...
        gui.handles.value_hardfilm1_GUI, gui.handles.unit_hardfilm1_GUI] = ...
        thin_films_properties_GUI(gui.handles.bg_film1_properties_GUI, ...
        position, 'Film 1 :');
    % Film 2
    [gui.handles.title_film2_GUI, gui.handles.title_thickfilm2_GUI, ...
        gui.handles.value_thickfilm2_GUI, gui.handles.unit_thickfilm2_GUI, ...
        gui.handles.title_youngfilm2_GUI, gui.handles.value_youngfilm2_GUI, ...
        gui.handles.unit_youngfilm2_GUI, gui.handles.title_poissfilm2_GUI, ...
        gui.handles.value_poissfilm2_GUI, gui.handles.title_hardfilm2_GUI, ...
        gui.handles.value_hardfilm2_GUI, gui.handles.unit_hardfilm2_GUI] = ...
        thin_films_properties_GUI(gui.handles.bg_film2_properties_GUI, ...
        position, 'Film 2 :');
    
    % Settings
    set([gui.handles.title_thicksub_GUI, gui.handles.value_thicksub_GUI, ...
        gui.handles.unit_thicksub_GUI], 'Visible', 'off');
    set(gui.handles.title_youngsub_GUI, 'String', 'YM =');
    
    guidata(gcf, gui);
    
    gui_handle = ishandle(gcf);
else
    fprintf(['<a href="https://code.google.com/p/yamlmatlab/">', ...
        'Please download YAML Matlab code first...!</a>']);
    dos('start https://code.google.com/p/yamlmatlab/ ');
    errordlg(['Please download YAML Matlab code first... --> ', ...
        'https://code.google.com/p/yamlmatlab/'], 'Error');
end

java_icon_nims;

end
