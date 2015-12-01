%% Copyright 2014 MERCIER David
function unit_data

get_unit;

gui = guidata(gcf);

set(gui.handles.unit_mindepth_GUI, 'String', gui.data.dispUnit);
set(gui.handles.unit_maxdepth_GUI, 'String', gui.data.dispUnit);

% Set unit factors
if strcmp(gui.data.loadUnit, 'nN')
    gui.data.loadFact = 1e-6;
elseif strcmp(gui.data.loadUnit, 'uN')
    gui.data.loadFact = 1e-3;
elseif strcmp(gui.data.loadUnit, 'mN')
    gui.data.loadFact = 1;
end

if strcmp(gui.data.dispUnit, 'nm')
    gui.data.dispFact = 1;
elseif strcmp(gui.data.dispUnit, 'um')
    gui.data.dispFact = 1e3;
elseif strcmp(gui.data.dispUnit, 'mm')
    gui.data.dispFact = 1e6;
end

if strcmp(gui.data.loadUnit, 'nN') == 1 && strcmp(gui.data.dispUnit, 'nm') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1e3;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e6;
    end
elseif strcmp(gui.data.loadUnit, 'nN') == 1 && strcmp(gui.data.dispUnit, 'um') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1e3;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1e6;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e9;
    end
elseif strcmp(gui.data.loadUnit, 'nN') == 1 && strcmp(gui.data.dispUnit, 'mm') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1e6;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1e9;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e12;
    end
elseif strcmp(gui.data.loadUnit, 'uN') == 1 && strcmp(gui.data.dispUnit, 'nm') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1e-3;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e3;
    end
elseif strcmp(gui.data.loadUnit, 'uN') == 1 && strcmp(gui.data.dispUnit, 'um') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1e3;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e6;
    end
elseif strcmp(gui.data.loadUnit, 'uN') == 1 && strcmp(gui.data.dispUnit, 'mm') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1e3;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1e6;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e9;
    end
elseif strcmp(gui.data.loadUnit, 'mN') == 1 && strcmp(gui.data.dispUnit, 'nm') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1e-6;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1e-3;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1;
    end
elseif strcmp(gui.data.loadUnit, 'mN') == 1 && strcmp(gui.data.dispUnit, 'um') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1e-3;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e3;
    end
elseif strcmp(gui.data.loadUnit, 'mN') == 1 && strcmp(gui.data.dispUnit, 'mm') == 1
    if strcmp(gui.data.stifUnit, 'N/m') == 1
        gui.data.stifFact = 1;
    elseif strcmp(gui.data.stifUnit, 'mN/um') == 1
        gui.data.stifFact = 1e3;
    elseif strcmp(gui.data.stifUnit, 'mN/nm') == 1
        gui.data.stifFact = 1e6;
    end
end

% ...for calculations only (not for plot)
gui.data.h_init_f       = gui.data.dispFact * gui.data.h_init; % in nm
gui.data.delta_h_init_f = gui.data.dispFact * gui.data.delta_h_init; % in nm
gui.data.P_init_f       = gui.data.loadFact * gui.data.P_init; % in mN
gui.data.delta_P_init_f = gui.data.loadFact * gui.data.delta_P_init; % in mN
gui.data.S_init_f       = gui.data.stifFact * gui.data.S_init; % in mN/nm
gui.data.delta_S_init_f = gui.data.stifFact * gui.data.delta_S_init; % in mN/nm

guidata(gcf, gui);

end