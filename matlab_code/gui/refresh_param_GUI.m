%% Copyright 2014 MERCIER David
function refresh_param_GUI
%% Function used to refresh the GUI in function of the number of thin films
gui = guidata(gcf);
viscoelastic = get(gui.handles.value_param2plotinyaxis_GUI, 'Value') >= 10;
elastic_list = ismember(get(gui.handles.value_param2plotinyaxis_GUI, 'Value'), [4 5]) && ...
    get(gui.handles.value_numthinfilm_GUI, 'Value') == 2;
old_elastic_list = ismember(gui.variables.y_axis_old, [4 5]) && ...
    gui.variables.num_thinfilm_old == 2;
hardness_comparison = get(gui.handles.value_param2plotinyaxis_GUI, 'Value') == 6 && ...
    get(gui.handles.value_param2plotinxaxis_GUI, 'Value') == 4;
if hardness_comparison
    set(gui.handles.cb_lines_plot_GUI, 'Enable', 'off');
    set(gui.handles.cb_SD_plot_GUI, 'Enable', 'off');
else
    set(gui.handles.cb_lines_plot_GUI, 'Enable', 'on');
    set(gui.handles.cb_SD_plot_GUI, 'Enable', 'on');
end

% Young's modulus and Hardness models
if get(gui.handles.value_param2plotinyaxis_GUI , 'Value') < 4
    set(gui.handles.title_modeldisp_GUI,       'Visible', 'off');
    set(gui.handles.value_modeldisp_GUI,       'Visible', 'off');
    set(gui.handles.title_corr_King_GUI,       'Visible', 'off');
    set(gui.handles.popup_corr_King_GUI,       'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Value',0);
    set(gui.handles.title_neta_corr_thickness_GUI, 'Visible', 'off');
    set(gui.handles.value_neta_corr_thickness_GUI, 'Visible', 'off');
else
    set(gui.handles.title_modeldisp_GUI,       'Visible', 'on');
    set(gui.handles.value_modeldisp_GUI,       'Visible', 'on');
    set(gui.handles.title_modeldisp_GUI,       'Visible', 'on');
    set(gui.handles.value_modeldisp_GUI,       'Visible', 'on');
    set(gui.handles.title_corr_King_GUI,       'Visible', 'on');
    set(gui.handles.popup_corr_King_GUI,       'Visible', 'on');
    set(gui.handles.cb_corr_thickness_GUI,     'Visible', 'on');
    set(gui.handles.title_neta_corr_thickness_GUI, 'Visible', 'on');
    set(gui.handles.value_neta_corr_thickness_GUI, 'Visible', 'on');
end

if (get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 6 && ...
        get(gui.handles.value_numthinfilm_GUI, 'Value') == 1)
    set(gui.handles.title_corr_King_GUI,       'Visible', 'off');
    set(gui.handles.popup_corr_King_GUI,       'Visible', 'off');
end

if get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 1
    set(gui.handles.title_model_GUI, ...
        'String', gui.handles.title_load_disp_model);
    set(gui.handles.value_model_GUI, ...
        'String', gui.handles.list_load_disp_model);
elseif get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 2
    set(gui.handles.title_model_GUI, ...
        'String', gui.handles.title_stiffness_model);
    set(gui.handles.value_model_GUI, ...
        'String', gui.handles.list_stiffness_model);
elseif get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 3
    set(gui.handles.title_model_GUI, ...
        'String', gui.handles.title_loadOverstiffnessSquared_model);
    set(gui.handles.value_model_GUI, ...
        'String', gui.handles.list_loadOverstiffnessSquared_model);
elseif get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 4 || ...
        get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 5
    if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
        set(gui.handles.title_model_GUI, ...
            'String', gui.handles.title_bilayermodel);
        set(gui.handles.value_model_GUI, ...
            'String', gui.handles.list_bilayermodel);
    elseif get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
        set(gui.handles.title_model_GUI, ...
            'String', gui.handles.title_multilayermodel);
        set(gui.handles.value_model_GUI, ...
            'String', gui.handles.list_multilayermodel);
    end
elseif get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 6
    if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
        set(gui.handles.title_model_GUI, ...
            'String', gui.handles.title_bilayermodel);
        set(gui.handles.value_model_GUI, ...
            'String', gui.handles.list_bilayermodel_plastic);
        set(gui.handles.value_models_Saha_GUI, ...
            'String', gui.handles.list_bilayermodel);
    elseif get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
        set(gui.handles.title_model_GUI, ...
            'String', gui.handles.title_multilayermodel);
        set(gui.handles.value_model_GUI, ...
            'String', gui.handles.list_multilayermodel_plastic);
        set(gui.handles.value_models_Saha_GUI, ...
            'String', gui.handles.list_multilayermodel);
    end
end

if get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 6
    if get(gui.handles.value_model_GUI, 'Value') > 3
        set(gui.handles.title_models_Saha_GUI, 'Visible', 'on');
        set(gui.handles.value_models_Saha_GUI, 'Visible', 'on');
        if get(gui.handles.value_models_Saha_GUI, 'Value') == 1
            set(gui.handles.value_models_Saha_GUI, 'Value', 2);
        end
    else
        set(gui.handles.title_models_Saha_GUI, 'Visible', 'off');
        set(gui.handles.value_models_Saha_GUI, 'Visible', 'off');
    end
else
    set(gui.handles.title_models_Saha_GUI, 'Visible', 'off');
    set(gui.handles.value_models_Saha_GUI, 'Visible', 'off');
end

if gui.variables.y_axis_old ~= ...
        get(gui.handles.value_param2plotinyaxis_GUI, 'Value') || ...
        gui.variables.num_thinfilm_old ~= ...
        get(gui.handles.value_numthinfilm_GUI, 'Value');
    set(gui.handles.value_model_GUI, 'Value', 1);
    if ~elastic_list || ~old_elastic_list
        set(gui.handles.value_elastic_models_GUI, 'Value', 1);
    end
end

if elastic_list
    set(gui.handles.value_elastic_models_GUI, ...
        'String', gui.handles.list_bilayermodel);
    selected = get(gui.handles.value_elastic_models_GUI, 'Value');
    selected = selected(selected > 1);
    if isempty(selected)
        selected = 1;
    end
    set(gui.handles.value_elastic_models_GUI, 'Value', selected);
    set(gui.handles.value_model_GUI, 'Value', selected(1));
    set(gui.handles.title_model_GUI, 'String', 'Elastic models (Ctrl-click)');
end

% Thin films properties
if get(gui.handles.value_numthinfilm_GUI, 'Value') == 1
    set(gui.handles.bg_film2_properties_GUI,   'Visible', 'off');
    set(gui.handles.bg_film1_properties_GUI,   'Visible', 'off');
    set(gui.handles.bg_film0_properties_GUI,   'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Value',0);
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
    set(gui.handles.bg_film0_properties_GUI,   'Visible', 'on');
    set(gui.handles.bg_film1_properties_GUI,   'Visible', 'off');
    set(gui.handles.bg_film2_properties_GUI,   'Visible', 'off');
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 3
    set(gui.handles.bg_film0_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film1_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film2_properties_GUI, 'Visible', 'off');
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
    set(gui.handles.bg_film0_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film1_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film2_properties_GUI, 'Visible', 'on');
end

if get(gui.handles.value_numthinfilm_GUI, 'Value') == 1 || viscoelastic
    set(gui.handles.title_model_GUI, 'Visible', 'off');
    set(gui.handles.value_model_GUI, 'Visible', 'off');
else
    set(gui.handles.title_model_GUI, 'Visible', 'on');
    if elastic_list
        set(gui.handles.value_model_GUI, 'Visible', 'off');
    else
        set(gui.handles.value_model_GUI, 'Visible', 'on');
    end
end
if elastic_list
    set(gui.handles.value_elastic_models_GUI, 'Visible', 'on');
else
    set(gui.handles.value_elastic_models_GUI, 'Visible', 'off');
end

% Residuals
if hardness_comparison
    set(gui.handles.pb_residual_plot_GUI, 'Visible', 'off');
elseif viscoelastic
    set(gui.handles.cb_corr_thickness_GUI, 'Visible', 'off');
    set(gui.handles.title_neta_corr_thickness_GUI, 'Visible', 'off');
    set(gui.handles.value_neta_corr_thickness_GUI, 'Visible', 'off');
    set(gui.handles.pb_residual_plot_GUI, 'Visible', 'off');
elseif elastic_list && numel(selected) > 1
    set(gui.handles.pb_residual_plot_GUI, 'Visible', 'off');
elseif get(gui.handles.value_model_GUI, 'Value') > 1
    set(gui.handles.pb_residual_plot_GUI, 'Visible', 'on');
elseif get(gui.handles.value_model_GUI, 'Value') == 1
    set(gui.handles.pb_residual_plot_GUI, 'Visible', 'off');
end

guidata(gcf, gui);

end