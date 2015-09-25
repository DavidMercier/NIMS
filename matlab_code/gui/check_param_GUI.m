%% Copyright 2014 MERCIER David
function check_param_GUI
%% Function to get values of different variables from the GUI
gui = guidata(gcf);

%% Empty inputs
set_default_values_txtbox(gui.handles.value_hardfilm0_GUI, '1');
set_default_values_txtbox(gui.handles.value_thickfilm0_GUI, '500');
set_default_values_txtbox(gui.handles.value_youngfilm0_GUI, '60');
set_default_values_txtbox(gui.handles.value_poissfilm0_GUI, '0.3');
set_default_values_txtbox(gui.handles.value_hardfilm1_GUI, '1');
set_default_values_txtbox(gui.handles.value_thickfilm1_GUI, '500');
set_default_values_txtbox(gui.handles.value_youngfilm1_GUI, '60');
set_default_values_txtbox(gui.handles.value_poissfilm1_GUI, '0.3');
set_default_values_txtbox(gui.handles.value_hardfilm2_GUI, '1');
set_default_values_txtbox(gui.handles.value_thickfilm2_GUI, '500');
set_default_values_txtbox(gui.handles.value_youngfilm2_GUI, '60');
set_default_values_txtbox(gui.handles.value_poissfilm2_GUI, '0.3');
set_default_values_txtbox(gui.handles.value_hardsub_GUI, '1');
set_default_values_txtbox(gui.handles.value_youngsub_GUI, '165');
set_default_values_txtbox(gui.handles.value_poisssub_GUI, '0.18');
set_default_values_txtbox(gui.handles.value_neta_corr_thickness_GUI, ...
    num2str(gui.config.numerics.thicknessCorrection_low));

if isempty(get(gui.handles.value_indenter_def_prop_GUI, 'String')) == 1
    refresh_indenters_GUI;
end

if isempty(get(gui.handles.value_indenter_ang_prop_GUI, 'String')) == 1
    refresh_indenters_GUI;
end

if isempty(get(gui.handles.value_C0_GUI, 'String')) == 1
    refresh_indenters_GUI;
end

end