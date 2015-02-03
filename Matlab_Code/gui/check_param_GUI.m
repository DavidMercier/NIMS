%% Copyright 2014 MERCIER David
function check_param_GUI
%% Function to get values of different variables from the GUI
gui = guidata(gcf);

%% Empty inputs
set_default_values_txtbox(gui.handles.value_thinfilm0_GUI, '500');
set_default_values_txtbox(gui.handles.value_youngfilm0_GUI, '60');
set_default_values_txtbox(gui.handles.value_poissfilm0_GUI, '0.3');
set_default_values_txtbox(gui.handles.value_thinfilm1_GUI, '500');
set_default_values_txtbox(gui.handles.value_youngfilm1_GUI, '60');
set_default_values_txtbox(gui.handles.value_poissfilm1_GUI, '0.3');
set_default_values_txtbox(gui.handles.value_thinfilm2_GUI, '500');
set_default_values_txtbox(gui.handles.value_youngfilm2_GUI, '60');
set_default_values_txtbox(gui.handles.value_poissfilm2_GUI, '0.3');
set_default_values_txtbox(gui.handles.value_youngsub_GUI, '165');
set_default_values_txtbox(gui.handles.value_poisssub_GUI, '0.18');

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