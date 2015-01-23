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
guidata(gcf, gui);

clean_data;
gui = guidata(gcf); guidata(gcf, gui);

if ~gui.flag.wrong_inputs
    if gui.flag.flag_no_csm ~= 1
        CSM_correction;
    end
    
    %% Getting parameters and Refreshing the GUI
    get_param_GUI;
    refresh_param_GUI;
    
    %% Get parameters
    model_set_parameters;
    gui = guidata(gcf); guidata(gcf, gui);
    
    %% Load-Displacement curve analysis
    if gui.variables.y_axis == 1
        model_load_disp;
    end
    
    %% Calculations of function area
    if gui.variables.y_axis > 3
        model_function_area;
        gui = guidata(gcf); guidata(gcf, gui);
    end
    
    %% Calculations of Young's modulus
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        model_elastic;
        %% Set model to use for calculations
        if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
            model_bilayer_elastic;
        elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 3 || ...
                get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
            model_multilayer_elastic;
        end
    elseif gui.variables.y_axis == 6
        gui.results.H = model_hardness(gui.data.P, gui.results.Ac);
    end
    
    % Be careful of the order of the 3 following lines, because gcf is
    % the waitbar during calculations !!!
    gui = guidata(gcf);
    delete(gui.handles.h_waitbar);
    guidata(gcf, gui);
    
    %% Plot data
    plot_exp_vs_mod_setvariables;
    gui = guidata(gcf); guidata(gcf, gui);
    
    if strcmp(get(gui.handles.cb_residual_plot_GUI, 'Visible'), 'on') == 1
        residual_plot_value = get(gui.handles.cb_residual_plot_GUI, 'Value');
        if residual_plot_value == 0
            plot_exp_vs_mod;
        else
            plot_residuals;
        end
    else
        plot_exp_vs_mod;
    end
    gui = guidata(gcf);
else
    delete(gui.handles.h_waitbar);
end
guidata(gcf, gui);

end