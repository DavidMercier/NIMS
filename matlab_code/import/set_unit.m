%% Copyright 2014 MERCIER David
function set_unit(handleGUI, unit)

gui = guidata(handleGUI);

if strcmp(unit(:,1), 'nm') == 1
    set(gui.handles.unitDisp_GUI, 'Value', 1);
elseif strcmp(unit(:,1), 'um') == 1
    set(gui.handles.unitDisp_GUI, 'Value', 2);
elseif strcmp(unit(:,1), 'mm') == 1
    set(gui.handles.unitDisp_GUI, 'Value', 3);
end

if strcmp(unit(:,2), 'nN') == 1
    set(gui.handles.unitLoad_GUI, 'Value', 1);
elseif strcmp(unit(:,2), 'uN') == 1
    set(gui.handles.unitLoad_GUI, 'Value', 2);
elseif strcmp(unit(:,2), 'mN') == 1
    set(gui.handles.unitLoad_GUI, 'Value', 3);
end

if strcmp(unit(:,3), 'N/m') == 1
    set(gui.handles.unitStif_GUI, 'Value', 1);
elseif strcmp(unit(:,3), 'mN/um') == 1
    set(gui.handles.unitStif_GUI, 'Value', 2);
elseif strcmp(unit(:,3), 'mN/nm') == 1
    set(gui.handles.unitStif_GUI, 'Value', 3);
end

end