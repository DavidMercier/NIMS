%% Copyright 2014 MERCIER David
function plot_properties
%% Function used to set plot properties
gui = guidata(gcf);

%% Initialization
set(gui.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);

xlabel(gui.axis.xlabelstr, 'Color', [0,0,0], 'FontSize', 14);
ylabel(gui.axis.ylabelstr, 'Color', [0,0,0], 'FontSize', 14);
if gui.axis.xmin < gui.axis.xmax
    xlim([gui.axis.xmin gui.axis.xmax]);
else
    xlim([gui.axis.xmax gui.axis.xmin]);
end
if gui.axis.ymin < gui.axis.ymax
    ylim([gui.axis.ymin gui.axis.ymax]);
else
    ylim([gui.axis.ymax gui.axis.ymin]);
end
set(gui.handles.AxisPlot_GUI, 'FontSize', 14);
set(gui.handles.plot_data, 'MarkerSize', 10);
for ii = 1:length(gui.handles.plot_data)
    gui.handles.plot_data(ii).LineWidth = 2;
end

legend(gui.axis.legend_str, 'Location', 'NorthWest');
title(gui.axis.title_str, 'FontSize', 18);

if get(gui.handles.cb_grid_plot_GUI, 'Value') == 1
    grid on;
else
    grid off;
end

guidata(gcf, gui);

end