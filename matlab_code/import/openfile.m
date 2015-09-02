%% Copyright 2014 MERCIER David
function openfile
%% Function used to open a data file and assign experimental results to variables
gui = guidata(gcf);
gui.data = struct;

%% Initialization
gui.handles.h_waitbar_load = waitbar(0, 'Import data in progress...');

gui.flag.flag = 0;

%% Get type on indenter used
gui.data.indenter_type_val = get(gui.handles.pm_set_indenter, 'Value');
gui.data.indenter_type_str = get_value_popupmenu(gui.handles.pm_set_indenter, ...
    get(gui.handles.pm_set_indenter, 'String'));

%% Open window to select file
title_importdata_Window = ...
    strcat('File Selector from', {' '}, char(gui.data.indenter_type_str));

if strfind(char(gui.data.indenter_type_str), 'MTS') >= 1
    extension_importdata_Window = '*.xls;*.txt;*.xlsx';
    flagMTS = 1;
    flagHys = 0;
elseif strfind(char(gui.data.indenter_type_str), 'Hys') >= 1
    extension_importdata_Window = '*.txt;*.dat';
    flagMTS = 0;
    flagHys = 1;
end

[gui.data.filename_data, gui.data.pathname_data, filterindex_data] = ...
    uigetfile(extension_importdata_Window, ...
    char(title_importdata_Window), gui.config.data.data_path);

if gui.data.pathname_data ~= 0
    gui.config.data.data_path = gui.data.pathname_data;
end
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
    %     movefile(datapath_config_filename,'./yaml_config_files');
end

if isequal(gui.data.filename_data,'')
    disp('User selected Cancel');
    gui.data.pathname_data = 'no_data';
    gui.data.filename_data = 'no_data';
    ext = '.nul';
    gui.flag.flag_data = 0;
    delete(gui.handles.h_waitbar_load);
else
    disp(['User selected', ...
        fullfile(gui.data.pathname_data, gui.data.filename_data)]);
    [pathstr, name, ext] = fileparts(gui.data.filename_data);
    gui.flag.flag_data = 1;
end

data2import = [gui.data.pathname_data, gui.data.filename_data];

if gui.flag.flag_data
    %% .txt file
    if strcmp (ext, '.txt') == 1
        
        comma2point_overwrite(data2import); % Replace comma with a point
        dataAll = importdata(gui.data.filename_data);
        if isfield(dataAll, 'textdata')
            data = dataAll.data;
        else
            data = textdata;
        end
        
        if flagMTS
            if size(data,2) == 3
                gui.data.h_init       = data(:,1);
                gui.data.delta_h_init = zeros(size(data,1),1);
                gui.data.P_init       = data(:,2);
                gui.data.delta_P_init = zeros(size(data,1),1);
                gui.data.S_init       = data(:,3);
                gui.data.delta_S_init = zeros(size(data,1),1);
                gui.flag.flag_no_csm  = 1;
                
            else
                gui.data.h_init       = data(:,1);
                gui.data.delta_h_init = data(:,2);
                gui.data.P_init       = data(:,3);
                gui.data.delta_P_init = data(:,4);
                gui.data.S_init       = data(:,5);
                gui.data.delta_S_init = data(:,6);
                gui.flag.flag_no_csm  = 0;
                
            end
            
        elseif flagHys
            gui.data.h_init       = data(:,2);
            gui.data.delta_h_init = zeros(size(data,1),1);
            gui.data.P_init       = data(:,4);
            gui.data.delta_P_init = zeros(size(data,1),1);
            gui.data.S_init       = 1./data(:,12); %Dynamic Comp. (nm/µN)
            gui.data.delta_S_init = zeros(size(data,1),1);
            gui.flag.flag_no_csm  = 0;
            
        end
        
        %% .xls file
    elseif strcmp (ext, '.xls') == 1 || strcmp (ext, '.xlsx') == 1
        [data,txt] = xlsread(data2import);
        L = txt(:,1); %limite
        TF_segm = strcmp(L, 'Hold Segment Type');
        y_index = find(TF_segm == 1);
        
        if isempty(y_index)
            clear TF; clear z;
            TF_segm = strcmp(L, 'Unload From Peak Segment Type');
            y_index = find(TF_segm == 1);
            
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
            
            try
                [data,txt]        = xlsread(data2import, 'Sample', data_index);
                NoSampleFlag = 0;
            catch
                [data,txt]        = xlsread(data2import);
                NoSampleFlag = 1;
            end
            
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
                if NoSampleFlag
                    data_clean(:,1) = data(:,x_index_disp-1);
                    data_clean(:,2) = data(:,x_index_load-1);
                    data_clean(:,3) = data(:,x_index_stiff-1);
                else
                    data_clean(:,1) = data(:,x_index_disp);
                    data_clean(:,2) = data(:,x_index_load);
                    data_clean(:,3) = data(:,x_index_stiff);
                end
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
                gui.data.h_init       = data(:,1);
                gui.data.delta_h_init = zeros(size(data,1),1);
                gui.data.P_init       = data(:,2);
                gui.data.delta_P_init = zeros(size(data,1),1);
                gui.data.S_init       = data(:,3);
                gui.data.delta_S_init = zeros(size(data,1),1);
                gui.flag.flag_no_csm  = 1;
                
            else
                gui.data.h_init       = data(:,1);
                gui.data.delta_h_init = data(:,2);
                gui.data.P_init       = data(:,3);
                gui.data.delta_P_init = data(:,4);
                gui.data.S_init       = data(:,5);
                gui.data.delta_S_init = data(:,6);
                gui.flag.flag_no_csm  = 0;
                
            end
        else
            helpdlg('Format of data in . xls file is not correct ! --> Please, see given examples...','!!!');
        end
        
    end
    delete(gui.handles.h_waitbar_load);
    
    guidata(gcf, gui);
    
    unit_data;
    gui = guidata(gcf); guidata(gcf, gui);
    
    set(gui.handles.value_param2plotinxaxis_GUI, 'Value',  1);
    set(gui.handles.value_param2plotinyaxis_GUI, 'Value',  1);
    set(gui.handles.value_mindepth_GUI,          'String', round(min(gui.data.h_init)));
    set(gui.handles.value_maxdepth_GUI,          'String', round(max(gui.data.h_init)));
    set(gui.handles.value_youngsub_GUI,          'String', 165);
    set(gui.handles.value_youngfilm0_GUI,        'String', 60);
    set(gui.handles.value_youngfilm1_GUI,        'String', 60);
    set(gui.handles.value_youngfilm2_GUI,        'String', 60);
    set(gui.handles.opendata_str_GUI,            'String', gui.data.filename_data);
    
    refresh_indenters_GUI;
    gui = guidata(gcf); guidata(gcf, gui);
    
    get_and_plot;
    gui = guidata(gcf); guidata(gcf, gui);
    
end

guidata(gcf, gui);

end
