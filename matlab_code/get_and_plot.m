%% Copyright 2014 MERCIER David
function get_and_plot
%% Function used to get and plot data
gui = guidata(gcf);

gui.handles.h_waitbar = waitbar(0, 'Calculations in progress...');
steps = 100;
for step = 1:steps
    waitbar(step / steps, gui.handles.h_waitbar);
end

%% Cleaning of data
gui.results = struct();
guidata(gcf, gui);

clean_data;
gui = guidata(gcf); guidata(gcf, gui);

if ~gui.flag.wrong_inputs
    if gui.flag.flag_no_csm ~= 1
        CSM_correction;
    end
    
    %% Refreshing the GUI and getting parameters and
    refresh_param_GUI;
    get_param_GUI;
    
    %% Get parameters
    model_set_parameters;
    gui = guidata(gcf); guidata(gcf, gui);
    
    %% Load-Displacement curve analysis
    if gui.variables.y_axis == 1
        model_load_disp;
        gui = guidata(gcf); guidata(gcf, gui);
    end
    
    %% Calculations of function area
    if gui.variables.y_axis > 3
        model_function_area;
        gui = guidata(gcf); guidata(gcf, gui);
    end
    
    %% Calculations of Young's modulus
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        [gui.results.Eeff_red,gui.results.Esample_red, gui.results.Esample] = ...
            model_elastic(gui.data.S, gui.results.Ac, gui.data.nuf, gcf);
        guidata(gcf, gui);
        %% Set model to use for calculations
        if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
            model_bilayer_elastic(gui.variables.val2);
        elseif get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
            model_multilayer_elastic(gui.variables.val2);
        end
    elseif gui.variables.y_axis == 6
        gui.results.H = model_hardness(gui.data.P, gui.results.Ac);
        guidata(gcf, gui);
        %% Set model to use for calculations
        if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
            model_bilayer_plastic(gui.variables.val2);
        elseif get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
            model_multilayer_plastic(gui.variables.val2);
        end
    end

    % Be careful of the order of the 3 following lines, because gcf is
    % the waitbar during calculations !!!
    gui = guidata(gcf);
    delete(gui.handles.h_waitbar);
    guidata(gcf, gui);
    
    % Refactor data for plot
    gui.data.h = gui.data.h/gui.data.dispFact;
    gui.data.delta_h = gui.data.delta_h/gui.data.dispFact;
    gui.data.P = gui.data.P/gui.data.loadFact;
    gui.data.delta_P = gui.data.delta_P/gui.data.loadFact;
    gui.data.S = gui.data.S/gui.data.stifFact;
    gui.data.delta_S = gui.data.delta_S/gui.data.stifFact;
    guidata(gcf, gui);
    
    %% Plot data
    plot_exp_vs_mod_setvariables;
    gui = guidata(gcf); guidata(gcf, gui);
    
    plot_exp_vs_mod;
    gui = guidata(gcf);
else
    warndlg(gui.flag.warnText, 'Input Error');
    delete(gui.handles.h_waitbar);
end
guidata(gcf, gui);

end