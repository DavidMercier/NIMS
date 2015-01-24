%% Copyright 2014 MERCIER David
function plot_properties
%% Function used to set plot properties
gui = guidata(gcf);

%% Initialization
set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);

xlabel(gui.axis.xlabelstr, 'Color', [0,0,0], 'FontSize', 14);
ylabel(gui.axis.ylabelstr, 'Color', [0,0,0], 'FontSize', 14);
xlim([gui.axis.xmin gui.axis.xmax]);
ylim([gui.axis.ymin gui.axis.ymax]);
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