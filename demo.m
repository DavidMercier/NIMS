%% Copyright 2014 MERCIER David
function gui_handle = demo
%% Function to run the Matlab GUI for the calculations of elastic-plastic properties
% of a multilayer system from indentation experiments with a conical indenter

%% Import data from YAML config files
gui = struct();
gui.config = struct();
gui.config.indenter = struct();
gui.config.data = struct();
gui.config.numerics = struct();

[gui.config.indenter, gui.config.data, ...
    gui.config.numerics, flag_YAML] = load_YAML_config_file;

%% Paths Management
try
    gui.config.NIMSroot = get_nims_root; % ensure that environment is set
catch
    [startdir, dummy1, dummy2] = fileparts(mfilename('fullpath'));
    cd(startdir);
    commandwindow;
    path_management;
end

%% Set Toolbox version and help paths
gui.config.name_toolbox = 'NIMS';
gui.config.version_toolbox = '3.0';
gui.config.url_help = 'http://nims.readthedocs.org/en/latest/';
gui.config.pdf_help = 'https://media.readthedocs.org/pdf/nims/latest/nims.pdf';

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