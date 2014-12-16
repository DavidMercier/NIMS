%% Copyright 2014 MERCIER David
function openfile
%% Function used to open a data file and assign experimental results to variables
gui = guidata(gcf);
gui.data = struct;

%% Initialization
gui.handles.h_waitbar_load = waitbar(0, 'Import data in progress...');

gui.flag.flag = 0;

%% Open window to select file
[gui.data.filename_data, gui.data.pathname_data, filterindex_data] = uigetfile([gui.config.data_path, '*.xls;*.txt'], 'File Selector');
% datapath_config_filename=sprintf('GUI_path_%s.yaml',getenv('USERNAME'));

%% Waitbar
steps = 1000;
for step = 1:steps
    waitbar(step / steps, gui.handles.h_waitbar_load);
end

%% Handle canceled file selection
if gui.data.filename_data == 0
    gui.data.filename_data = '';
end
if gui.data.pathname_data == 0
    gui.data.pathname_data = '';
else
    gui.config.data_path = gui.data.pathname_data;
    %     config.data_path = pathname_data;
    %     WriteYaml(datapath_config_filename,config);
    %     movefile(datapath_config_filename,'./YAML_config_files');
end

if isequal(gui.data.filename_data,'')
    disp('User selected Cancel');
    gui.data.filename_data = 'no_data';
    ext = '.nul';
    
else
    disp(['User selected', fullfile(gui.data.pathname_data, gui.data.filename_data)]);
    [pathstr, name, ext] = fileparts(gui.data.filename_data);
    
end

%% .txt file
if strcmp (ext, '.txt') == 1
    
    comma2point_overwrite(gui.data.filename_data); % Replace comma with a point
    data = load(gui.data.filename_data); %importdata ??
    
    if size(data,2) == 3
        gui.data.h_init       = data(:,1); % in nm
        gui.data.delta_h_init = zeros(size(data,1),1); % in nm
        gui.data.P_init       = data(:,2); % in mN
        gui.data.delta_P_init = zeros(size(data,1),1); % in mN
        gui.data.S_init       = 10^-6.*data(:,3); % from N/m to mN/nm
        gui.data.delta_S_init = zeros(size(data,1),1); % from N/m to mN/nm
        gui.flag.flag_no_csm  = 1;
        
    else
        gui.data.h_init       = data(:,1); % in nm
        gui.data.delta_h_init = data(:,2); % in nm
        gui.data.P_init       = data(:,3); % in mN
        gui.data.delta_P_init = data(:,4); % in mN
        gui.data.S_init       = 10^-6.*data(:,5); % from N/m to mN/nm
        gui.data.delta_S_init = 10^-6.*data(:,6); % from N/m to mN/nm
        gui.flag.flag_no_csm  = 0;
        
    end
    
    %% .xls file
elseif strcmp (ext, '.xls') == 1
    [data,txt] = xlsread(gui.data.filename_data);
    L = txt(:,1); %limite
    TF = strcmp(L, 'Hold Segment Type');
    y_index = find(TF == 1);
    
    if isempty(y_index)
        clear TF; clear z;
        TF = strcmp(L, 'Unload From Peak Segment Type');
        y_index = find(TF == 1);
        
        if isempty(y_index)
            gui.flag.flag_xls_data = 1; % No segment
            
        else
            gui.flag.flag_xls_data = 2; % Segment defined by XP MTS Software
            
        end
        
    elseif length(y_index) == 1
        gui.flag.flag_xls_data = 2; % Segment defined by XP MTS Software
        
    else
        gui.flag.flag_xls_data = 3;
        
    end
    
    if gui.flag.flag_xls_data == 2
        
        data_index = sprintf('%c%d:%c%d', 'B', 1, 'I', y_index);
        
        [data,txt]        = xlsread(gui.data.filename_data, 'Sample', data_index);
        L                 = txt(1,:); %limite
        TF_disp           = strcmp(L, 'Displacement Into Surface');
        x_index_disp      = find(TF_disp==1);
        TF_dev            = strcmp(L, 'STANDARD DEVIATION (Displacement Into Surface)');
        x_index_disp_dev  = find(TF_dev == 1);
        TF_load           = strcmp(L, 'Load On Sample');
        x_index_load      = find(TF_load==1);
        TF_dev            = strcmp(L, 'STANDARD DEVIATION (Load On Sample)');
        x_index_load_dev  = find(TF_dev == 1);
        TF_stiff          = strcmp(L, 'Harmonic Contact Stiffness');
        x_index_stiff     = find(TF_stiff==1);
        TF_dev            = strcmp(L, 'STANDARD DEVIATION (Harmonic Contact Stiffness)');
        x_index_stiff_dev = find(TF_dev == 1);
        
        if isempty(x_index_disp_dev) && isempty(x_index_load_dev) && isempty(x_index_stiff_dev)
            data_clean(:,1) = data(:,x_index_disp);
            data_clean(:,2) = data(:,x_index_load);
            data_clean(:,3) = data(:,x_index_stiff);
            clear data;
            
            data(:,1) = data_clean(:,1);
            data(:,2) = data_clean(:,2);
            data(:,3) = data_clean(:,3);
            
        elseif length(x_index_disp_dev) == 1 && length(x_index_load_dev) == 1  && length(x_index_stiff_dev) == 1
            data_clean(:,1) = data(:,x_index_disp);
            data_clean(:,2) = data(:,x_index_disp_dev);
            data_clean(:,3) = data(:,x_index_load);
            data_clean(:,4) = data(:,x_index_load_dev);
            data_clean(:,5) = data(:,x_index_stiff);
            data_clean(:,6) = data(:,x_index_stiff_dev);
            clear data;
            
            data(:,1) = data_clean(:,1);
            data(:,2) = data_clean(:,2);
            data(:,3) = data_clean(:,3);
            data(:,4) = data_clean(:,4);
            data(:,5) = data_clean(:,5);
            data(:,6) = data_clean(:,6);
            
        else
            gui.flag.flag_xls_data = 3;
        end
    end
    
    if gui.flag.flag_xls_data == 1 || gui.flag.flag_xls_data == 2
        if size(data,2) == 3
            gui.data.h_init       = data(:,1); % in nm
            gui.data.delta_h_init = zeros(size(data,1),1); % in nm
            gui.data.P_init       = data(:,2); % in mN
            gui.data.delta_P_init = zeros(size(data,1),1); % in mN
            gui.data.S_init       = 10^-6.*data(:,3); % from N/m to mN/nm
            gui.data.delta_S_init = zeros(size(data,1),1); % from N/m to mN/nm
            gui.flag.flag_no_csm  = 1;
            
        else
            gui.data.h_init       = data(:,1); % in nm
            gui.data.delta_h_init = data(:,2); % in nm
            gui.data.P_init       = data(:,3); % in mN
            gui.data.delta_P_init = data(:,4); % in mN
            gui.data.S_init       = 10^-6.*data(:,5); % from N/m to mN/nm
            gui.data.delta_S_init = 10^-6.*data(:,6); % from N/m to mN/nm
            gui.flag.flag_no_csm  = 0;
            
        end
    else
        helpdlg('Format of data in . xls file is not correct ! --> Please, see given examples...','!!!');
    end
    
end
delete(gui.handles.h_waitbar_load);

%% Initialization
if strcmp (ext, '.nul') == 1
    gui.flag.flag_data = 0;
    
else
    set(gui.handles.value_param2plotinxaxis_GUI, 'Value',  1);
    set(gui.handles.value_param2plotinyaxis_GUI, 'Value',  1);
    set(gui.handles.value_mindepth_GUI,          'String', round(min(gui.data.h_init)));
    set(gui.handles.value_maxdepth_GUI,          'String', round(max(gui.data.h_init)));
    set(gui.handles.value_youngsub_GUI,          'String', 165);
    set(gui.handles.value_youngfilm0_GUI,        'String', 60);
    set(gui.handles.value_youngfilm1_GUI,        'String', 60);
    set(gui.handles.value_youngfilm2_GUI,        'String', 60);
    set(gui.handles.opendata_str_GUI,            'String', gui.data.filename_data);
    
    gui.flag.flag_data = 1;
    guidata(gcf, gui);
    
    refresh_indenters_GUI;
    gui = guidata(gcf); guidata(gcf, gui);
    
    get_and_plot;
    gui = guidata(gcf); guidata(gcf, gui);
    
end

guidata(gcf, gui);

end

