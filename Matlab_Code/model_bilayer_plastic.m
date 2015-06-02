%% Copyright 2014 MERCIER David
function model_bilayer_plastic(val2)
%% Function used to set the bilayer plastic model
gui = guidata(gcf);

gui.results.Hf = 0;

gui.axis.legend2 = 'Results with the bilayer model';
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