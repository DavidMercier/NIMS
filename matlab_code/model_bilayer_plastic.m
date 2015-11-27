%% Copyright 2014 MERCIER David
function model_bilayer_plastic(val2)
%% Function used to set the bilayer plastic model
gui = guidata(gcf);

%% Setting variables & parameters
gui.results.Hf_fit = 0;
gui.results.t_corr = 0;
gui.results.Hf = 0;

% Thickness correction
if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    gui.results.t_corr = gui.data.t - ...
        (gui.variables.thickness_correctionFactor .* gui.results.hc);
else
    gui.results.t_corr = gui.data.t;
end

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
        
        OPTIONS = algoMinimization;
        
        if val2 == 2 %KaoByrne (1981)
            model_kao(OPTIONS);
            gui = guidata(gcf); guidata(gcf, gui);
        elseif val2 == 3 %Saha (2002)
            gui.results.Hf = model_saha(gui.data.S, gui.data.P, ...
                gui.results.Em_red, gcf);
        elseif val2 == 4 %Mercier (2010)
            gui.results.Hf = model_mercier(gui.data.S, gui.data.P, ...
                gui.results.Ef_red, gcf);
        end
        guidata(gcf, gui);
    end
    
elseif val2 == 1 % No Bilayer Model
    emptyVariables;
    gui = guidata(gcf); guidata(gcf, gui);
    
end

set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
guidata(gcf, gui);

end