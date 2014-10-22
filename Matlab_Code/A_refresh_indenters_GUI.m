%% Copyright 2014 MERCIER David
function A_refresh_indenters_GUI(init, varargin)
%% Function used to refresh the interface in function of the selected indenter
% init: variable to initialize the interface
if nargin < 1
    init = 1;
end

gui = guidata(gcf);

list_indenters = get(gui.handles.value_indentertype_GUI, 'String');
num_indenters  = get(gui.handles.value_indentertype_GUI, 'Value');
indenter_id    = list_indenters(num_indenters, :);

for ii = 1:1:length(gui.config.Indenter_IDs)
    func_area = getfield(gui.config, {1}, indenter_id{':'}, {':'});
    func_area = cell2mat(func_area(:));
    
    if strcmp(indenter_id, gui.config.Indenter_IDs(ii)) == 1
        [gui.data.indenter_id_str] = indenter_id{:};
        
        if strcmp(gui.data.indenter_id_str(1:4), 'Berk') == 1
            set(gui.handles.bg_Berkovich_tip_GUI, 'Visible', 'on');
            set(gui.handles.bg_Vickers_tip_GUI,   'Visible', 'off');
            set(gui.handles.bg_conical_tip_GUI,   'Visible', 'off');
            set(gui.handles.value_C1_GUI, 'String', num2str(func_area(1)));
            set(gui.handles.value_C2_GUI, 'String', num2str(func_area(2)));
            set(gui.handles.value_C3_GUI, 'String', num2str(func_area(3)));
            set(gui.handles.value_C4_GUI, 'String', num2str(func_area(4)));
            set(gui.handles.value_C5_GUI, 'String', num2str(func_area(5)));
            set(gui.handles.value_indenterberk_prop_GUI, 'String', num2str(func_area(6)));
            gui.data.indenter_tip_radius = get(gui.handles.value_indenterberk_prop_GUI, 'String');
            gui.data.indenter_tip_angle = '70.32'; %Equivalent semi-angle at the apex in degrees
            
        elseif strcmp(gui.data.indenter_id_str(1:4), 'Vick') == 1
            set(gui.handles.bg_Berkovich_tip_GUI, 'Visible', 'off');
            set(gui.handles.bg_Vickers_tip_GUI, 'Visible', 'on');
            set(gui.handles.bg_conical_tip_GUI, 'Visible', 'off');
            set(gui.handles.value_indentervickers_prop_GUI, 'String', num2str(func_area(1)));
            gui.data.indenter_tip_radius = get(gui.handles.value_indentervickers_prop_GUI, 'String');
            gui.data.indenter_tip_angle = '70.2996'; %Equivalent semi-angle at the apex in degrees
            
        elseif strcmp(gui.data.indenter_id_str(1:4), 'Coni') == 1
            set(gui.handles.bg_Berkovich_tip_GUI, 'Visible', 'off');
            set(gui.handles.bg_Vickers_tip_GUI,   'Visible', 'off');
            set(gui.handles.bg_conical_tip_GUI,   'Visible', 'on');
            set(gui.handles.value_indentercon_ang_prop_GUI, 'String', num2str(func_area(1)));
            set(gui.handles.value_indentercon_def_prop_GUI, 'String', num2str(func_area(2)));
            gui.data.indenter_tip_radius = get(gui.handles.value_indentercon_def_prop_GUI, 'String'); % Tip radius in nm
            gui.data.indenter_tip_angle = get(gui.handles.value_indentercon_ang_prop_GUI, 'String'); % Angle in degrees
            
        end
    end
    %% Setting indeter material properties
    list_indenters_material = get(gui.handles.value_indentermaterial_GUI, 'String');
    num_indenters_material  = get(gui.handles.value_indentermaterial_GUI, 'Value');
    gui.data.indenter_material = list_indenters_material(num_indenters_material, :);
    guidata(gcf, gui);
    
    if isfield(gui.config.Indenter_material_properties, gui.data.indenter_material) == 1
        gui.data.indenter_material_properties = gui.config.Indenter_material_properties.(gui.data.indenter_material{1});
        gui.data.indenter_material_ym = cell2mat(gui.data.indenter_material_properties(1));
        gui.data.indenter_material_pr = cell2mat(gui.data.indenter_material_properties(2));
    else
        warndlg('Missing indenter material properties ! Update the YAML config file and refresh the toolbox...');
    end
end

guidata(gcf, gui);

if init
    if gui.flag.flag_data == 0
        helpdlg('Import data first !', '!!!');
        
    else
        
        A_get_and_plot;
        gui = guidata(gcf); guidata(gcf, gui);
        
        gui.flag.flag = 1;
        
    end
    
    guidata(gcf, gui);
end

end