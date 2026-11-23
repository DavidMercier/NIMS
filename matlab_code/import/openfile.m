%% Copyright 2014 MERCIER David
function openfile
%% Function used to open a data file and assign experimental results to variables
gui = guidata(gcf);
gui.data = struct;

%% Initialization
gui.handles.h_waitbar_load = waitbar(0, 'Import data in progress...');

gui.flag.flag = 0;
loading_segment_marked = false;
unloading = struct('h', [], 'P', [], 'delta_P', []);

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
    if strcmp (ext, '.txt') == 1 || strcmp (ext, '.dat') == 1
        
        comma2point_overwrite(data2import); % Replace comma with a point
        dataAll = importdata(data2import);
        if isfield(dataAll, 'data')
            data = dataAll.data;
        else
            data = dataAll;
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
                set(gui.handles.cb_SD_plot_GUI, 'Value', 0, 'Visible', 'off');
                
            else
                gui.data.h_init       = data(:,1);
                gui.data.delta_h_init = data(:,2);
                gui.data.P_init       = data(:,3);
                gui.data.delta_P_init = data(:,4);
                gui.data.S_init       = data(:,5);
                gui.data.delta_S_init = data(:,6);
                gui.flag.flag_no_csm  = 0;
                set(gui.handles.cb_SD_plot_GUI, 'Value', 1, 'Visible', 'on');
                
            end
            
        elseif flagHys
            set_unit(gui.MainWindows, {'nm', 'uN', 'N/m'});
            gui.data.h_init       = data(:,2);
            gui.data.delta_h_init = zeros(size(data,1),1);
            gui.data.P_init       = data(:,4);
            gui.data.delta_P_init = zeros(size(data,1),1);
            gui.data.S_init       = 1./data(:,12); %Dynamic Comp. (nm/µN)
            gui.data.delta_S_init = zeros(size(data,1),1);
            gui.flag.flag_no_csm  = 0;
            set(gui.handles.cb_SD_plot_GUI, 'Value', 0, 'Visible', 'off');
            try
                [storageStiffness, lossStiffness] = ...
                    hysitron_viscoelastic_stiffness(data2import, data);
            catch exception
                if strcmp(exception.identifier, 'NIMS:Viscoelastic:InvalidColumns') || ...
                        strcmp(exception.identifier, 'NIMS:Viscoelastic:InvalidUnits')
                    warning(exception.identifier, '%s', exception.message);
                    storageStiffness = [];
                    lossStiffness = [];
                else
                    delete(gui.handles.h_waitbar_load);
                    rethrow(exception);
                end
            end
            if ~isempty(storageStiffness)
                gui.data.storage_stiffness_init = storageStiffness;
                gui.data.loss_stiffness_init = lossStiffness;
            end
            
        end
        
        %% .xls file
    elseif strcmp (ext, '.xls') == 1 || strcmp (ext, '.xlsx') == 1
        
        [STATUS, SHEETS] = xlsfinfo(data2import);
        
        if sum(strcmp(SHEETS, 'Sample')) == 1
            sheetName = 'Sample';
            NoSampleFlag = 0;
        elseif sum(strcmp(SHEETS, 'Analyst Project')) == 1
            [dataAP, txtAP] = xlsread(data2import, 'Analyst Project');
            [pathstr, sheetName,ext] = fileparts(char(txtAP(3,1)));
            sheetName = [sheetName, ext];
            NoSampleFlag = 0;
        else
            NoSampleFlag = 1;
        end
        
        if ~NoSampleFlag
            [data,~,raw] = xlsread(data2import, sheetName);
        else
            [data,~,raw] = xlsread(data2import);
        end

        if isempty(raw)
            error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
                'The spreadsheet contains no data.');
        end
        L = raw(:,1);
        y_index = find(strcmp(L, 'Hold Segment Type') | ...
            strcmp(L, 'Unload From Peak Segment Type'), 1);
        loading_segment_marked = ~isempty(y_index);
        
        if isempty(y_index)
            TF_segm = strcmp(L, 'END');
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

            if loading_segment_marked
                try
                    unloading = mts_unloading_segment(raw);
                catch exception
                    if ~strcmp(exception.identifier, 'NIMS:LoadingSegment:InvalidSpreadsheet')
                        rethrow(exception);
                    end
                    unloading.message = exception.message;
                    warning('NIMS:UnloadingSegment:Unavailable', ...
                        'Unloading data could not be imported: %s', exception.message);
                end
            end
            [data, unit] = mts_segment_data(raw, y_index - 1);
            set_unit(gui.MainWindows, unit);
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
                set(gui.handles.cb_SD_plot_GUI, 'Value', 0, 'Visible', 'off');
            else
                gui.data.h_init       = data(:,1);
                gui.data.delta_h_init = data(:,2);
                gui.data.P_init       = data(:,3);
                gui.data.delta_P_init = data(:,4);
                gui.data.S_init       = data(:,5);
                gui.data.delta_S_init = data(:,6);
                gui.flag.flag_no_csm  = 0;
                set(gui.handles.cb_SD_plot_GUI, 'Value', 1, 'Visible', 'on');
            end
        else
            helpdlg('Format of data in . xls file is not correct ! --> Please, see given examples...','!!!');
        end
        
    end
    delete(gui.handles.h_waitbar_load);

    if ~loading_segment_marked
        [gui.data, discarded, unloading] = extract_loading_segment(gui.data);
        if discarded > 0
            fprintf('Loading segment: discarded %d points after peak load.\n', discarded);
        end
    end
    gui.data.unloading = unloading;
    
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
    set(gui.MainWindows, 'Name', [gui.config.name_toolbox, ' - Version_', ...
        gui.config.version_toolbox, ' - ', name]);
    gui = guidata(gcf); guidata(gcf, gui);
    
end

guidata(gcf, gui);

end