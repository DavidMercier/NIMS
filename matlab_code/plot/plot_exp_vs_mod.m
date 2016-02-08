%% Copyright 2014 MERCIER David
function plot_exp_vs_mod
%% Function to plot experimental data + model
gui = guidata(gcf);

%% Initialization
set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
cla;
gui.axis.legend_str = '';
gui.data.t = gui.data.t / gui.data.dispFact;

gui.flag.residuals = 0;

gui.variables.log_plot_value = get(gui.handles.cb_log_plot_GUI, 'Value');

if get(gui.handles.cb_lines_plot_GUI, 'value') == 1
    if gui.variables.log_plot_value == 0
        if gui.variables.x_axis == 1
            if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
                gui.axis.xline1 = [gui.data.t0, gui.data.t0];
                gui.axis.yline1 = [0, gui.axis.ymax];
            elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 3
                gui.axis.xline1 = [gui.data.t0+gui.data.t1, gui.data.t0+gui.data.t1];
                gui.axis.yline1 = [0, gui.axis.ymax];
                gui.axis.xline2 = [gui.data.t1, gui.data.t1];
                gui.axis.yline2 = [0, gui.axis.ymax];
            elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
                gui.axis.xline1 = [gui.data.t0+gui.data.t1+gui.data.t2, gui.data.t0+gui.data.t1+gui.data.t2];
                gui.axis.yline1 = [0, gui.axis.ymax];
                gui.axis.xline2 = [gui.data.t1+gui.data.t2, gui.data.t1+gui.data.t2];
                gui.axis.yline2 = [0, gui.axis.ymax];
                gui.axis.xline3 = [gui.data.t2, gui.data.t2];
                gui.axis.yline3 = [0, gui.axis.ymax];
            end
        elseif gui.variables.x_axis == 3
            if get(gui.handles.value_numthinfilm_GUI, 'Value') == 2
                gui.axis.xline1 = [1, 1];
                gui.axis.yline1 = [0, gui.axis.ymax];
            elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 3
                gui.axis.xline1 = [(gui.data.t1+gui.data.t0)/gui.data.t, (gui.data.t1+gui.data.t0)/gui.data.t];
                gui.axis.yline1 = [0, gui.axis.ymax];
                gui.axis.xline2 = [1, 1];
                gui.axis.yline2 = [0, gui.axis.ymax];
            elseif get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
                gui.axis.xline1 = [(gui.data.t0+gui.data.t1+gui.data.t2)/gui.data.t, (gui.data.t0+gui.data.t1+gui.data.t2)/gui.data.t];
                gui.axis.yline1 = [0, gui.axis.ymax];
                gui.axis.xline2 = [(gui.data.t1+gui.data.t2)/gui.data.t, (gui.data.t1+gui.data.t2)/gui.data.t];
                gui.axis.yline2 = [0, gui.axis.ymax];
                gui.axis.xline3 = [1, 1];
                gui.axis.yline3 = [0, gui.axis.ymax];
            end
        else
            gui.axis.xline1 = 0; gui.axis.yline1 = 0;
            gui.axis.xline2 = 0; gui.axis.yline2 = 0;
            gui.axis.xline3 = 0; gui.axis.yline3 = 0;
        end
    end
    
    if gui.variables.log_plot_value == 1
        if gui.variables.x_axis == 1 || gui.variables.x_axis == 3
            if get(gui.handles.value_numthinfilm_GUI, 'Value') > 1
                if (min(gui.axis.y2plot) < min(gui.axis.y2plot_2))
                    gui.axis.yline1 = [min(gui.axis.y2plot), gui.axis.ymax];
                else
                    gui.axis.yline1 = [min(gui.axis.y2plot_2), gui.axis.ymax];
                end
            end
            if get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
                if (min(gui.axis.y2plot) < min(gui.axis.y2plot_2))
                    gui.axis.yline2 = [min(gui.axis.y2plot), gui.axis.ymax];
                else
                    gui.axis.yline2 = [min(gui.axis.y2plot_2), gui.axis.ymax];
                end
            end
            if get(gui.handles.value_numthinfilm_GUI, 'Value') > 3
                if (min(gui.axis.y2plot) < min(gui.axis.y2plot_2))
                    gui.axis.yline3 = [min(gui.axis.y2plot), gui.axis.ymax];
                else
                    gui.axis.yline3 = [min(gui.axis.y2plot_2), gui.axis.ymax];
                end
            end
        end
    end
end

%% Definiton of the plot
if get(gui.handles.cb_SD_plot_GUI, 'Value') == 1
    if gui.variables.val2 == 1
        gui.handles.plot_data = errorbar(gui.axis.x2plot,gui.axis.y2plot, gui.axis.delta_y2plot, 'rx');
        hold on;
        gui.axis.legend_str = 'Initial data';
    else
        gui.handles.plot_data = errorbar(...
            gui.axis.x2plot,gui.axis.y2plot, gui.axis.delta_y2plot, 'rx');
        hold on;
        gui.handles.plot_model = plot(gui.axis.x2plot, gui.axis.y2plot_2, 'b-');
        hold on;
        gui.axis.legend_str = {'Initial data', gui.axis.legend2};
    end
    
else
    if gui.variables.val2 == 1
        gui.handles.plot_data = plot(gui.axis.x2plot,gui.axis.y2plot, 'rx');
        hold on;
        gui.axis.legend_str = 'Initial data';
    else
        gui.handles.plot_data = plot(gui.axis.x2plot,gui.axis.y2plot, 'rx');
        hold on;
        gui.handles.plot_model = plot(gui.axis.x2plot, gui.axis.y2plot_2, 'b-');
        hold on;
        gui.axis.legend_str = {'Initial data', gui.axis.legend2};
    end
end
hold on;

%% Plot properties
if get(gui.handles.cb_lines_plot_GUI, 'value') == 1
    if get(gui.handles.value_numthinfilm_GUI, 'Value') > 1
        gui.handles.plot_line1 = plot(gui.axis.xline1, gui.axis.yline1, '--ko');
        set(gui.handles.plot_line1, 'MarkerSize', 10, 'LineWidth', 2);
        hold on;
        text(gui.axis.xline1(1), ...
            gui.axis.ymax-0.05*gui.axis.ymax, ...
            [' \leftarrow Interface Film0/Substrate'], ...
            'FontSize', 12);
    end
    if get(gui.handles.value_numthinfilm_GUI, 'Value') > 2
        gui.handles.plot_line2 = plot(gui.axis.xline2, gui.axis.yline2, '--ko');
        set(gui.handles.plot_line2, 'MarkerSize', 10, 'LineWidth', 2);
        hold on;
        text(gui.axis.xline2(1), ...
            gui.axis.ymax-0.10*gui.axis.ymax, ...
            [' \leftarrow Interface Film1/Film0'], ...
            'FontSize', 12);
    end
    if get(gui.handles.value_numthinfilm_GUI, 'Value') == 4
        gui.handles.plot_line3 = plot(gui.axis.xline3, gui.axis.yline3, '--ko');
        set(gui.handles.plot_line3, 'MarkerSize', 10, 'LineWidth', 2);
        hold on;
        text(gui.axis.xline3(1), ...
            gui.axis.ymax-0.15*gui.axis.ymax, ...
            [' \leftarrow Interface Film2/Film1'], ...
            'FontSize', 12);
    end
end

if gui.variables.num_thinfilm == 1
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        set(gui.handles.value_youngsub_GUI, ...
            'String', round(mean(gui.results.Esample)));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when $h < t$) = ', ...
            num2str(round(mean(gui.results.Esample))), 'GPa'];
    elseif gui.variables.y_axis == 6
        gui.axis.title_str = strcat('Mean Hardness = ', ...
            num2str(round(mean(gui.results.cleaned_H.*1000)./10)./100), 'GPa');
    end
    
elseif gui.variables.num_thinfilm == 2
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        if gui.variables.val2 > 5 && gui.variables.val2 < 10
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean Young''s modulus of the film (when $h < t$) = ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa'];
            
        elseif gui.variables.val2 == 10
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean Young''s modulus of the film (when $h < t$) = ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa / $n$(Perriot) = ', ...
                num2str(gui.results.Ef_sol_fit(2))];
            
        elseif gui.variables.val2 == 11
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            gui.axis.title_str = ...
                ['Mean Young''s modulus of the film (when $h < t$) = ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa / $E_s$ = ', ...
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
                ['Mean Young''s modulus of the film (when $h < t$) = ', ...
                num2str(round(gui.results.Ef_sol_fit(1))), 'GPa / $\alpha$ = ', ...
                num2str(round(1000*gui.results.Ef_sol_fit(2))/1000)];
            
        end
        
    elseif gui.variables.y_axis == 6
        if gui.variables.val2 == 1
            gui.axis.title_str = strcat('Mean Hardness of the film = ', ...
                num2str(round(mean(gui.results.H.*1000)./10)./100), 'GPa');
        else
            set(gui.handles.value_youngfilm0_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            set(gui.handles.value_hardfilm0_GUI, ...
                'String', num2str(round(mean(gui.results.Hf_fit*1000)./10)./100));
            gui.axis.title_str = ...
                ['Mean hardness from analytical model (when $h < t$) = ', ...
                num2str(round(mean(gui.results.Hf.*1000)./10)./100), 'GPa'];
        end
    end
    
elseif gui.variables.num_thinfilm == 3
    if gui.variables.y_axis == 4
        set(gui.handles.value_youngfilm1_GUI, ...
            'String', round(gui.results.Ef_sol_fit(1)));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when $h < t$) = ', ...
            num2str(round(gui.results.Ef_sol_fit(1))), 'GPa'];
        
    elseif gui.variables.y_axis == 5
        set(gui.handles.value_youngfilm1_GUI, ...
            'String', round(gui.results.Ef_sol));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when $h < t$) = ', ...
            num2str(round(gui.results.Ef_sol)), 'GPa'];
        
    elseif gui.variables.y_axis == 6
        if gui.variables.val2 == 1
            gui.axis.title_str = strcat('Mean Hardness of the film = ', ...
                num2str(round(mean(gui.results.H.*1000)./10)./100), 'GPa');
        else
            set(gui.handles.value_youngfilm1_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            set(gui.handles.value_hardfilm1_GUI, ...
                'String', num2str(round(mean(gui.results.Hf_fit*1000)./10)./100));
            gui.axis.title_str = ...
                ['Mean hardness from analytical model (when $h < t$) = ', ...
                num2str(round(mean(gui.results.Hf.*1000)./10)./100), 'GPa'];
        end
    end
    
elseif gui.variables.num_thinfilm == 4
    if gui.variables.y_axis == 4
        set(gui.handles.value_youngfilm2_GUI, ...
            'String', round(gui.results.Ef_sol_fit(1)));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when $h < t$) = ', ...
            num2str(round(gui.results.Ef_sol_fit(1))), 'GPa'];
        
    elseif gui.variables.y_axis == 5
        set(gui.handles.value_youngfilm2_GUI, ...
            'String', round(gui.results.Ef_sol));
        gui.axis.title_str = ...
            ['Mean Young''s modulus of the film (when $h < t$) = ', ...
            num2str(round(gui.results.Ef_sol)), 'GPa'];
        
    elseif gui.variables.y_axis == 6
        if gui.variables.val2 == 1
            gui.axis.title_str = strcat('Mean Hardness of the film = ', ...
                num2str(round(mean(gui.results.H.*1000)./10)./100), 'GPa');
        else
            set(gui.handles.value_youngfilm2_GUI, ...
                'String', round(gui.results.Ef_sol_fit(1)));
            set(gui.handles.value_hardfilm2_GUI, ...
                'String', num2str(round(mean(gui.results.Hf_fit*1000)./10)./100));
            gui.axis.title_str = ...
                ['Mean hardness from analytical model (when $h < t$) = ', ...
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