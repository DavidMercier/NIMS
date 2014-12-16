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
        gui = guidata(gcf); guidata(gcf, gui);
    end
    
    %% Refreshing of the GUI
    refresh_param_GUI;
    gui = guidata(gcf); guidata(gcf, gui);
    
    get_param_GUI;
    gui = guidata(gcf); guidata(gcf, gui);
    
    %% Calculations of elastic properties
    model_elastic_set;
    gui = guidata(gcf); guidata(gcf, gui);
    
    model_elastic;
    gui = guidata(gcf); guidata(gcf, gui);
    
    %% Set model to use for calculations
    if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
        model_bilayer_elastic;
        gui = guidata(gcf); guidata(gcf, gui);
        
    elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 3 || get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
        model_multilayer_elastic;
        gui = guidata(gcf); guidata(gcf, gui);
        
    else
        gui.results.H = model_hardness(gui.data.P, gui.results.Ac);
    end
    
    delete(gui.handles.h_waitbar);
    guidata(gcf, gui);
    
    %% Plot data
    plot_exp_vs_mod_setvariables;
    gui = guidata(gcf); guidata(gcf, gui);
    
    if strcmp(get(gui.handles.cb_residual_plot_GUI, 'Visible'), 'on') == 1
        residual_plot_value = get(gui.handles.cb_residual_plot_GUI, 'Value');
        
        if residual_plot_value == 0
            plot_exp_vs_mod;
            gui = guidata(gcf); guidata(gcf, gui);
            
        else
            plot_residuals;
            gui = guidata(gcf); guidata(gcf, gui);
            
        end
        
    else
        plot_exp_vs_mod;
        gui = guidata(gcf); guidata(gcf, gui);
        
    end
else
    delete(gui.handles.h_waitbar);
end
guidata(gcf, gui);

end