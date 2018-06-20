%% Copyright 2014 MERCIER David
function refresh_indenters_GUI(init, varargin)
%% Function used to refresh the interface in function of the selected indenter
% init: variable to initialize the interface
if nargin < 1
    init = 1;
end

gui = guidata(gcf);

list_indenters = get(gui.handles.value_indentertype_GUI, 'String');
num_indenters  = get(gui.handles.value_indentertype_GUI, 'Value');
indenter_id    = list_indenters(num_indenters, :);

for ii = 1:1:length(gui.config.indenter.Indenter_IDs)
    try
        func_area = getfield(gui.config.indenter, {1}, indenter_id{':'}, {':'});
        func_area = cell2mat(func_area(:));
    catch
        func_area = '';
        edit('indenters_config.yaml');
        errordlg('Wrong inputs for the indenter definition! Define your indenter in the indenters_config.yaml...');
        break        
    end
    
    if ~isempty(func_area)
        if strcmp(indenter_id, gui.config.indenter.Indenter_IDs(ii)) == 1
            [gui.data.indenter_id_str] = indenter_id{:};
            
            set(gui.handles.bg_indenter_tip_GUI, 'Visible', 'on');
            
            if strcmp(gui.data.indenter_id_str(1:4), 'Coni') == 1
                tip_angle = func_area(11);
            elseif strcmp(gui.data.indenter_id_str(1:4), 'Berk') == 1
                tip_angle = gui.config.indenter.thetaeq_Berkovich;
            elseif strcmp(gui.data.indenter_id_str(1:4), 'Vick') == 1
                tip_angle = gui.config.indenter.thetaeq_Vickers;
            elseif strcmp(gui.data.indenter_id_str(1:4), 'Cube') == 1
                tip_angle = gui.config.indenter.thetaeq_CubeCorner;
            end
            
            if strcmp(gui.data.indenter_id_str(1:4), 'Coni') == 1
                set(gui.handles.value_indenter_ang_prop_GUI, ...
                    'String', num2str(func_area(11)));
            elseif strcmp(gui.data.indenter_id_str(1:4), 'Berk') == 1
                set(gui.handles.value_indenter_ang_prop_GUI, ...
                    'String', num2str(gui.config.indenter.thetaeq_Berkovich));
            elseif strcmp(gui.data.indenter_id_str(1:4), 'Vick') == 1
                set(gui.handles.value_indenter_ang_prop_GUI, ...
                    'String', num2str(gui.config.indenter.thetaeq_Vickers));
            elseif strcmp(gui.data.indenter_id_str(1:4), 'Cube') == 1
                set(gui.handles.value_indenter_ang_prop_GUI, ...
                    'String', num2str(gui.config.indenter.thetaeq_CubeCorner));
            end
            
            if func_area(1) == 0
                C0 = pi * tand(tip_angle)^2;
                set(gui.handles.value_C0_GUI, 'String', num2str(C0));
            else
                C0 = func_area(1);
            end
            
            set(gui.handles.value_indenter_def_prop_GUI, 'String', num2str(func_area(10)));
            set(gui.handles.value_C0_GUI, 'String', num2str(C0));
            set(gui.handles.value_C1_GUI, 'String', num2str(func_area(2)));
            set(gui.handles.value_C2_GUI, 'String', num2str(func_area(3)));
            set(gui.handles.value_C3_GUI, 'String', num2str(func_area(4)));
            set(gui.handles.value_C4_GUI, 'String', num2str(func_area(5)));
        end
        %% Setting indenter material properties
        list_indenters_material = get(gui.handles.value_indentermaterial_GUI, 'String');
        num_indenters_material  = get(gui.handles.value_indentermaterial_GUI, 'Value');
        gui.data.indenter_material = list_indenters_material(num_indenters_material, :);
        guidata(gcf, gui);
        
        if isfield(gui.config.indenter.Indenter_material_properties, gui.data.indenter_material)
            gui.data.indenter_material_properties = ...
                gui.config.indenter.Indenter_material_properties.(gui.data.indenter_material{1});
            gui.data.indenter_material_ym = ...
                cell2mat(gui.data.indenter_material_properties(1));
            gui.data.indenter_material_pr = ...
                cell2mat(gui.data.indenter_material_properties(2));
        else
            warndlg('Missing indenter material properties ! Update the YAML config file and refresh the toolbox...');
        end
    end
end

guidata(gcf, gui);

if init
    if gui.flag.flag_data == 0
        helpdlg('Import data first !', '!!!');
    else
        get_and_plot;
        gui = guidata(gcf); guidata(gcf, gui);
        
        gui.flag.flag = 1;
    end
    guidata(gcf, gui);
end

end