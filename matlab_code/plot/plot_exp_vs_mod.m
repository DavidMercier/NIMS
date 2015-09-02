%% Copyright 2014 MERCIER David
function plot_exp_vs_mod
%% Function to plot experimental data + model
gui = guidata(gcf);

%% Initialization
set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
cla;
gui.axis.legend_str = '';
gui.data.t = gui.data.t / gui.data.dispFact;

gui.variables.log_plot_value = get(gui.handles.cb_log_plot_GUI, 'Value');

if gui.variables.log_plot_value == 0
    
    if gui.variables.x_axis == 1
        gui.axis.xline = [gui.data.t, gui.data.t];
        gui.axis.yline = [0, gui.axis.ymax];
    elseif gui.variables.x_axis == 3
        gui.axis.xline = [1, 1];
        gui.axis.yline = [0, gui.axis.ymax];
    else
        gui.axis.xline = 0;
        gui.axis.yline = 0;
    end
    
elseif gui.variables.log_plot_value == 1
    
    if gui.variables.x_axis == 1
        gui.axis.xline = [gui.data.t, gui.data.t];
        
        if (min(gui.axis.y2plot) < min(gui.axis.y2plot_2))
            gui.axis.yline = [min(gui.axis.y2plot), gui.axis.ymax];
        else
            gui.axis.yline = [min(gui.axis.y2plot_2), gui.axis.ymax];
        end
        
    elseif gui.variables.x_axis == 3
        gui.axis.xline = [1, 1];
        
        if min(gui.axis.y2plot) < min(gui.axis.y2plot_2)
            gui.axis.yline = [min(gui.axis.y2plot), gui.axis.ymax];
        else
            gui.axis.yline = [min(gui.axis.y2plot_2), gui.axis.ymax];
        end
        
    else
        gui.axis.xline = 0;
        gui.axis.yline = 0;
    end
end

%% Definiton of the plot
if gui.variables.log_plot_value == 0
    if gui.variables.y_axis == 1 || gui.variables.y_axis > 3
        if gui.variables.val2 == 1
            gui.handles.plot_data = plot(...
                gui.axis.x2plot, gui.axis.y2plot, 'rx', ...
                gui.axis.xline, gui.axis.yline,  '--ko');
            gui.axis.legend_str = 'Initial data';
        else
            gui.handles.plot_data = plot(...
                gui.axis.x2plot, gui.axis.y2plot, 'rx', ...
                gui.axis.x2plot, gui.axis.y2plot_2, 'b-', ...
                gui.axis.xline, gui.axis.yline,  '--ko');
            gui.axis.legend_str = {'Initial data', gui.axis.legend2};
        end
        
    elseif gui.variables.y_axis == 2 || gui.variables.y_axis == 3 || ...
            gui.variables.y_axis == 6
        gui.handles.plot_data = plot(...
            gui.axis.x2plot, gui.axis.y2plot, 'rx', ...
            gui.axis.xline, gui.axis.yline, '--ko');
        gui.axis.legend_str = {'Initial data'};
    end
    
elseif gui.variables.log_plot_value == 1
    if gui.variables.y_axis == 1 || gui.variables.y_axis > 3
        if gui.variables.val2 == 1
            gui.handles.plot_data = loglog(...
                gui.axis.x2plot, gui.axis.y2plot, 'rx', ...
                gui.axis.xline, gui.axis.yline,  '--ko');
            gui.axis.legend_str = 'Initial data';
        else
            gui.handles.plot_data = loglog(...
                gui.axis.x2plot, gui.axis.y2plot, 'rx', ...
                gui.axis.x2plot, gui.axis.y2plot_2, 'b-', ...
                gui.axis.xline, gui.axis.yline,  '--ko');
            gui.axis.legend_str = {'Initial data', gui.axis.legend2};
        end
        
    elseif gui.variables.y_axis == 2 || gui.variables.y_axis == 3 || ...
            gui.variables.y_axis == 6
        gui.handles.plot_data = loglog(...
            gui.axis.x2plot, gui.axis.y2plot, 'rx', ...
            gui.axis.xline, gui.axis.yline, '--ko');
        gui.axis.legend_str = {'Initial data'};
    end
end

%% Plot properties
if get(gui.handles.value_numthinfilm_GUI, 'Value') ~= 1
    text(gui.axis.xline(1), ...
        gui.axis.ymax-0.05*gui.axis.ymax, ...
        ' \leftarrow Thin Film 0', 'FontSize', 12);
end

if gui.variables.num_thinfilm == 1
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        set(gui.handles.value_youngsub_GUI, ...
            'String', round(mean(gui.results.Esample)));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when h < t) = ', ...
            num2str(round(mean(gui.results.Esample))), 'GPa'];
    elseif gui.variables.y_axis == 6
        gui.axis.title_str = strcat('Mean Hardness= ', ...
            num2str(round(mean(gui.results.cleaned_H.*1000)./10)./100), 'GPa');
    end
    
elseif gui.variables.num_thinfilm == 2
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        if gui.variables.val2 > 5 && gui.variables.val2 < 10
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean Young''s modulus of the film (when h < t)= ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa'];
            
        elseif gui.variables.val2 == 10
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean Young''s modulus of the film (when h < t)= ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa / n(Perriot et al.)= ', ...
                num2str(gui.results.Ef_sol_fit(2))];
            
        elseif gui.variables.val2 == 11
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean Young''s modulus of the film (when h < t)= ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa / Es= ', ...
                num2str(round(gui.results.Ef_sol_fit(2))), 'GPa'];
            
        elseif gui.variables.val2 == 2 || ...
                gui.variables.val2 == 3 || ...
                gui.variables.val2 == 4 || ...
                gui.variables.val2 == 5 || ...
                gui.variables.val2 == 12 || ...
                gui.variables.val2 == 13
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean Young''s modulus of the film (when h < t)= ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa / alpha= ', ...
                num2str(round(1000*gui.results.Ef_sol_fit(2))/1000)];
            
        end
        
    elseif gui.variables.y_axis == 6
        if gui.variables.val2 == 1
            gui.axis.title_str = strcat('Mean Hardness of the film= ', ...
                num2str(round(mean(gui.results.H.*1000)./10)./100), 'GPa');
        else
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean hardness of the film (when h < t)= ', ...
                num2str(round(mean(gui.results.Hf.*1000)./10)./100), 'GPa'];
        end
    end
    
elseif gui.variables.num_thinfilm == 3
    if gui.variables.y_axis == 4
        set(gui.handles.value_youngfilm1_GUI, ...
            'String', round(gui.results.Ef_sol_fit(1)));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when h < t)= ', ...
            num2str(round(gui.results.Ef_sol_fit(1))), 'GPa'];
        
    elseif gui.variables.y_axis == 5
        set(gui.handles.value_youngfilm1_GUI, ...
            'String', round(gui.results.Ef_sol));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when h < t)= ', ...
            num2str(round(gui.results.Ef_sol)), 'GPa'];
        
    elseif gui.variables.y_axis == 6
        if gui.variables.val2 == 1
            gui.axis.title_str = strcat('Mean Hardness of the film= ', ...
                num2str(round(mean(gui.results.H.*1000)./10)./100), 'GPa');
        else
            set(gui.handles.value_youngfilm1_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean hardness of the film (when h < t)= ', ...
                num2str(round(mean(gui.results.Hf.*1000)./10)./100), 'GPa'];
        end
        
    end
    
elseif gui.variables.num_thinfilm == 4
    if gui.variables.y_axis == 4
        set(gui.handles.value_youngfilm2_GUI, ...
            'String', round(gui.results.Ef_sol_fit(1)));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when h < t)= ', ...
            num2str(round(gui.results.Ef_sol_fit(1))), 'GPa'];
        
    elseif gui.variables.y_axis == 5
        set(gui.handles.value_youngfilm2_GUI, ...
            'String', round(gui.results.Ef_sol));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when h < t)= ', ...
            num2str(round(gui.results.Ef_sol)), 'GPa'];
        
    elseif gui.variables.y_axis == 6
        if gui.variables.val2 == 1
            gui.axis.title_str = strcat('Mean Hardness of the film= ', ...
                num2str(round(mean(gui.results.H.*1000)./10)./100), 'GPa');
        else
            set(gui.handles.value_youngfilm2_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean hardness of the film (when h < t)= ', ...
                num2str(round(mean(gui.results.Hf.*1000)./10)./100), 'GPa'];
        end
        
    end
    
end

%% Plot properties
gui.axis.ymin = 0;

set(gui.handles.pb_residual_plot_GUI, 'string', 'Residuals');
set(gui.handles.pb_residual_plot_GUI, 'Callback', 'plot_selection(2)');

guidata(gcf, gui);

plot_properties;

end
