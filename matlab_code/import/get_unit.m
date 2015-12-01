%% Copyright 2014 MERCIER David
function get_unit

gui = guidata(gcf);

loadUnit_val = get(gui.handles.unitLoad_GUI, 'Value');
loadUnit_list = get(gui.handles.unitLoad_GUI, 'String');
gui.data.loadUnit = loadUnit_list(loadUnit_val, :);

dispUnit_val = get(gui.handles.unitDisp_GUI, 'Value');
dispUnit_list = get(gui.handles.unitDisp_GUI, 'String');
gui.data.dispUnit = dispUnit_list(dispUnit_val, :);

stifUnit_val = get(gui.handles.unitStif_GUI, 'Value');
stifUnit_list = get(gui.handles.unitStif_GUI, 'String');
gui.data.stifUnit = stifUnit_list(stifUnit_val, :);

guidata(gcf, gui);

end