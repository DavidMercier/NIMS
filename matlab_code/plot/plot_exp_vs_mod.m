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

if gui.variables.x_axis == 4 && gui.variables.y_axis == 6
    guidata(gcf, gui);
    plot_hardness_comparison;
    return;
end

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

comparison = isfield(gui.results, 'elastic_comparison');
if comparison
    models = gui.results.elastic_comparison;
    colors = lines(numel(models));
    set(gui.handles.plot_model, 'Color', colors(1,:));
    gui.axis.legend_str = cell(1, numel(models) + 1);
    gui.axis.legend_str{1} = 'Initial data';
    for ii = 1:numel(models)
        if gui.variables.y_axis == 4
            values = models{ii}.Em_red;
        else
            values = models{ii}.Ef_red;
        end
        if isfield(models{ii}, 'korsunsky_params')
            gui.axis.legend_str{ii+1} = sprintf('%s (shallow asymptote = %.3g GPa reduced)', ...
                models{ii}.name, models{ii}.korsunsky_params(1));
        else
            gui.axis.legend_str{ii+1} = sprintf('%s (Ef = %.3g GPa)', ...
                models{ii}.name, models{ii}.Ef_sol_fit(1));
        end
        if models{ii}.exitflag <= 0
            gui.axis.legend_str{ii+1} = [gui.axis.legend_str{ii+1}, ' - fit did not converge'];
        end
        if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1 && ...
                ~models{ii}.thickness_corrected
            gui.axis.legend_str{ii+1} = [gui.axis.legend_str{ii+1}, ' - no thickness correction'];
        end
        if ii > 1
            plot(gui.axis.x2plot, values, '-', 'Color', colors(ii,:), ...
                'LineWidth', 2);
        end
        finite_values = values(isfinite(values));
        if ~isempty(finite_values)
            gui.axis.ymax = max(gui.axis.ymax, max(finite_values));
        end
    end
end

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

if comparison
    gui.axis.title_str = 'Elastic model comparison';
elseif gui.variables.num_thinfilm == 1
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
    
elseif isfield(gui.results, 'puchi_cabrera') && ismember(gui.variables.y_axis, [4 5])
    if gui.variables.num_thinfilm == 3
        filmControl = gui.handles.value_youngfilm1_GUI;
    else
        filmControl = gui.handles.value_youngfilm2_GUI;
    end
    set(filmControl, 'String', num2str(gui.results.Ef_sol_fit));
    gui.axis.title_str = sprintf( ...
        'Puchi-Cabrera %s: fitted top-film $E$ = %.3g GPa (fixed weights; nominal thickness)', ...
        strrep(gui.results.puchi_cabrera.model, '_', ' '), gui.results.Ef_sol_fit);
    if gui.results.exitflag <= 0
        gui.axis.title_str = [gui.axis.title_str, ' (fit did not converge)'];
    end

elseif gui.variables.num_thinfilm == 2
    if gui.variables.y_axis == 4 || gui.variables.y_axis == 5
        if gui.variables.val2 == 14
            p = gui.results.korsunsky_params;
            gui.axis.title_str = sprintf( ...
                'Korsunsky fit: $e_1^\\prime$=%.3g, $e_2^\\prime$=%.3g GPa, $\\beta_0$=%.3g, $\\eta$=%.3g', ...
                p(1), p(2), p(3), p(4));
            if gui.results.exitflag <= 0
                gui.axis.title_str = [gui.axis.title_str, ' (fit did not converge)'];
            end
        elseif gui.variables.val2 > 5 && gui.variables.val2 < 10
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

function plot_hardness_comparison
gui = guidata(gcf);
gui.axis.xlabelstr = 'Sample hardness (GPa)';
gui.axis.ylabelstr = 'Estimated film hardness (GPa)';
gui.axis.xmin = 0;
gui.axis.xmax = 0;
gui.axis.ymin = 0;
gui.axis.ymax = 0;
gui.axis.legend_str = 'Estimated film hardness';

if gui.variables.num_thinfilm == 1 || gui.variables.val2 == 1
    gui.axis.x2plot = NaN;
    gui.axis.y2plot = NaN;
    gui.axis.title_str = 'Select a film and a hardness model';
else
    sample = gui.results.H(:);
    if gui.variables.num_thinfilm == 2 && ismember(gui.variables.val2, [2 3 4])
        film = repmat(gui.results.Hf_fit(1), size(sample));
        gui.axis.legend_str = 'Fitted film hardness (constant)';
    else
        film = gui.results.Hf(:);
    end
    if numel(sample) ~= numel(film) || ~isreal(sample) || ~isreal(film)
        error('NIMS:HardnessPlot:InvalidData', ...
            'Sample and film hardness must be matching real vectors.');
    end
    valid = isfinite(sample) & sample >= 0 & isfinite(film) & film >= 0;
    if ~any(valid)
        error('NIMS:HardnessPlot:NoValidSamples', ...
            'No finite nonnegative sample and film hardness pairs are available.');
    end
    if any(~valid)
        warning('NIMS:HardnessPlot:InvalidSamples', ...
            'Excluded %d invalid sample and film hardness pairs.', sum(~valid));
    end
    gui.axis.x2plot = sample(valid);
    gui.axis.y2plot = film(valid);
    gui.axis.title_str = 'Film hardness versus sample hardness';
end
gui.handles.plot_data = plot(gui.axis.x2plot, gui.axis.y2plot, 'rx');
guidata(gcf, gui);
plot_properties;
end