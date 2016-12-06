%% Copyright 2014 MERCIER David
function plot_properties
%% Function used to set plot properties
gui = guidata(gcf);

%% Initialization
set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);

hXLabel = xlabel(gui.axis.xlabelstr, 'Color', [0,0,0], 'FontSize', 14);
hYLabel = ylabel(gui.axis.ylabelstr, 'Color', [0,0,0], 'FontSize', 14);

if gui.axis.xmin < gui.axis.xmax
    xlim([gui.axis.xmin gui.axis.xmax]);
elseif gui.axis.xmin > gui.axis.xmax
    xlim([gui.axis.xmax gui.axis.xmin]);
end
if gui.axis.ymin < gui.axis.ymax
    ylim([gui.axis.ymin gui.axis.ymax]);
elseif gui.axis.ymin > gui.axis.ymax
    ylim([gui.axis.ymax gui.axis.ymin]);
end
if gui.axis.xmax == 0
    xlim auto;
end
if gui.axis.ymax == 0
    ylim auto;
end

set(gui.handles.AxisPlot_GUI, 'FontSize', 14); %'TickLabelInterpreter', 'tex'
set(gui.handles.plot_data, 'MarkerSize', 10, 'LineWidth', 2);

if gui.flag.residuals == 0
    if gui.variables.val2 ~= 1
        set(gui.handles.plot_model, 'MarkerSize', 10, 'LineWidth', 2);
    end
end

list_Location = listLocationLegend;
LocationNumber = get(gui.handles.value_legend_location, 'Value');

hLeg = legend(gui.axis.legend_str, 'Location', char(list_Location(LocationNumber)));
hTitle = title(gui.axis.title_str, 'FontSize', 18);
set([hXLabel, hYLabel, hLeg, hTitle], 'Interpreter', 'Latex');

% Grid
if get(gui.handles.cb_grid_plot_GUI, 'Value') == 1
    grid on;
else
    grid off;
end

% LogLog plot
ax = get(gcf,'CurrentAxes');
if gui.variables.log_plot_value == 0
    set(ax,'XScale','linear','YScale','linear');
elseif gui.variables.log_plot_value == 1
    set(ax,'XScale','log','YScale','log');
end

guidata(gcf, gui);

end