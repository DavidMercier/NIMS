%% Copyright 2014 MERCIER David
function gui_handle = demo
%% Function to run the Matlab GUI for the calculations of elastic-plastic properties
% of a multilayer system from indentation experiments with a conical indenter

%% Paths Management
try
    get_nims_root; % ensure that environment is set
catch
    [startdir, dummy1, dummy2] = fileparts(mfilename('fullpath'));
    cd(startdir);
    commandwindow;
    path_management;
end

%% Import data from YAML config files
gui.config = struct();
gui.config.indenter = struct();
gui.config.data = struct();
gui.config.numerics = struct();

[gui.config.indenter, gui.config.data, ...
    gui.config.numerics, flag_YAML] = load_YAML_config_file;

%% Set Toolbox version and help paths
gui.config.name_toolbox = 'NIMS';
gui.config.version_toolbox = '2.5';
gui.config.url_help = 'http://nims.readthedocs.org/en/latest/';

guidata(gcf, gui);

%% GUI building
set_GUI;

%% Encapsulation of data into the GUI
gui = guidata(gcf); guidata(gcf, gui);

%% Help menu
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
    
    %% Set properties of thin films
    thin_films_properties_GUI;
    
    %% Encapsulation of data into the GUI
    gui = guidata(gcf); guidata(gcf, gui);
    
    gui_handle = ishandle(gcf);
else
    fprintf(['<a href="https://code.google.com/p/yamlmatlab/">', ...
        'Please download YAML Matlab code first...!</a>']);
    dos('start https://code.google.com/p/yamlmatlab/ ');
    errordlg(['Please download YAML Matlab code first... --> ', ...
        'https://code.google.com/p/yamlmatlab/'], 'Error');
end

end