%% Copyright 2014 MERCIER David
function model_multilayer_plastic(val2)
%% Function used to calculate hardness in multilayer system
gui = guidata(gcf);

%% Setting variables & parameters
gui.results.Hf = 0;

gui.results.ac2 = gui.results.ac;
gui.axis.legend2 = 'Results with the multilayer model';

% Thickness correction
if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    gui.results.t2_corr = gui.data.t2 - ...
        (gui.variables.thickness_correctionFactor .* gui.results.hc);
else
    gui.results.t2_corr = gui.data.t2;
end

if gui.variables.num_thinfilm == 4
    gui.results.ac1 = gui.results.ac2 + ((2.*gui.data.t2)./pi);
    gui.results.t1_corr = gui.data.t1;
    
elseif gui.variables.num_thinfilm == 3
    gui.results.ac1 = gui.results.ac;
    
    if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
        gui.results.t1_corr = gui.data.t1 - ...
            (gui.variables.thickness_correctionFactor .* gui.results.hc);
    else
        gui.results.t1_corr = gui.data.t1;
    end
end

gui.results.ac0     = gui.results.ac1 + ((2.*gui.data.t1)./pi);
gui.results.t0_corr = gui.data.t0;
guidata(gcf, gui);

%% Optimization of Young's modulus of the thin film
[gui.results.Eeff_red,gui.results.Esample_red, gui.results.Esample] = ...
    model_elastic(gui.data.S, gui.results.Ac, gui.data.nuf, gcf);
guidata(gcf, gui);

model_bilayer_elastic(gui.variables.val3);
gui = guidata(gcf); guidata(gcf, gui);

%% Hardness of the thin film calculated with Saha's method
if val2 ~= 1
    if gui.variables.y_axis == 6
        
        if val2 == 2 %Saha (2002)
            gui.results.Hf = model_saha(gui.data.S, gui.data.P, ...
                gui.results.Em_red, gcf);
        end
        guidata(gcf, gui);
    end
    
elseif val2 == 1 % No Bilayer Model
    
    % Preallocation
    gui.results.Hf = NaN(length(gui.data.h), 1);
    
    for ii = 1:1:length(gui.data.h)
        gui.results.Hf(ii) = 0;
        gui.results.Hf     = gui.results.Ef.';
    end
end

set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
guidata(gcf, gui);

end