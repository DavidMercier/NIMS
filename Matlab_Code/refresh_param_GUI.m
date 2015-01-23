%% Copyright 2014 MERCIER David
function refresh_param_GUI
%% Function used to refresh the GUI in function of the number of thin films
gui = guidata(gcf);

if get(gui.handles.value_numthinfilm_GUI, 'Value') == 1
    set(gui.handles.bg_film2_properties_GUI,   'Visible', 'off');
    set(gui.handles.bg_film1_properties_GUI,   'Visible', 'off');
    set(gui.handles.bg_film0_properties_GUI,   'Visible', 'off');
    set(gui.handles.title_bilayermodel_GUI,    'Visible', 'off');
    set(gui.handles.value_bilayermodel_GUI,    'Visible', 'off');
    set(gui.handles.title_multilayermodel_GUI, 'Visible', 'off');
    set(gui.handles.value_multilayermodel_GUI, 'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Value',0);
    
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
    set(gui.handles.bg_film0_properties_GUI,   'Visible', 'on');
    set(gui.handles.bg_film1_properties_GUI,   'Visible', 'off');
    set(gui.handles.bg_film2_properties_GUI,   'Visible', 'off');
    set(gui.handles.title_multilayermodel_GUI, 'Visible', 'off');
    set(gui.handles.value_multilayermodel_GUI, 'Visible', 'off');
    
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 3
    set(gui.handles.bg_film0_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film1_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film2_properties_GUI, 'Visible', 'off');
    set(gui.handles.title_bilayermodel_GUI,  'Visible', 'off');
    set(gui.handles.value_bilayermodel_GUI,  'Visible', 'off');
    
elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
    set(gui.handles.bg_film0_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film1_properties_GUI, 'Visible', 'on');
    set(gui.handles.bg_film2_properties_GUI, 'Visible', 'on');
    set(gui.handles.title_bilayermodel_GUI,  'Visible', 'off');
    set(gui.handles.value_bilayermodel_GUI,  'Visible', 'off');
    
end

if get(gui.handles.value_bilayermodel_GUI, 'Value') > 1
    if get(gui.handles.value_param2plotinyaxis_GUI, 'Value') == 3 || ...
            get(gui.handles.value_param2plotinyaxis_GUI, 'Value') == 4
        set(gui.handles.cb_residual_plot_GUI, 'Visible', 'on');
    end
elseif get(gui.handles.value_multilayermodel_GUI, 'Value') > 1
    if get(gui.handles.value_param2plotinyaxis_GUI, 'Value') == 3 || ...
            get(gui.handles.value_param2plotinyaxis_GUI, 'Value') == 4
        set(gui.handles.cb_residual_plot_GUI, 'Visible', 'on');
    end
else
    set(gui.handles.cb_residual_plot_GUI, 'Value', 0);
    set(gui.handles.cb_residual_plot_GUI, 'Visible', 'off');
end

if get(gui.handles.value_param2plotinyaxis_GUI , 'Value') < 4
    set(gui.handles.title_modeldisp_GUI,       'Visible', 'off');
    set(gui.handles.value_modeldisp_GUI,       'Visible', 'off');
    set(gui.handles.title_bilayermodel_GUI,    'Visible', 'off');
    set(gui.handles.value_bilayermodel_GUI,    'Visible', 'off');
    set(gui.handles.title_multilayermodel_GUI, 'Visible', 'off');
    set(gui.handles.value_multilayermodel_GUI, 'Visible', 'off');
    set(gui.handles.title_corr_King_GUI,       'Visible', 'off');
    set(gui.handles.popup_corr_King_GUI,       'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Visible', 'off');
    set(gui.handles.cb_corr_thickness_GUI,     'Value',0);
else
    set(gui.handles.title_modeldisp_GUI,       'Visible', 'on');
    set(gui.handles.value_modeldisp_GUI,       'Visible', 'on');
    set(gui.handles.title_corr_King_GUI,       'Visible', 'on');
    set(gui.handles.popup_corr_King_GUI,       'Visible', 'on');
end

if get(gui.handles.value_param2plotinyaxis_GUI , 'Value') == 1
    set(gui.handles.title_loaddisp_model_GUI, 'Visible', 'on');
    set(gui.handles.value_loaddisp_model_GUI, 'Visible', 'on');
else
    set(gui.handles.title_loaddisp_model_GUI, 'Visible', 'off');
    set(gui.handles.value_loaddisp_model_GUI, 'Visible', 'off');
end

guidata(gcf, gui);

end