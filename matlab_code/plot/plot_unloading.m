function plot_unloading
% Display measured unloading data without applying loading models.
gui = guidata(gcf);
set(gui.handles.value_param2plotinxaxis_GUI, 'Value', 1, 'Enable', 'off');
set(gui.handles.cb_lines_plot_GUI, 'Enable', 'off');
set(gui.handles.value_model_GUI, 'Enable', 'off');
set(gui.handles.value_elastic_models_GUI, 'Enable', 'off');
set(gui.handles.pb_residual_plot_GUI, 'Visible', 'off');
ax = gui.handles.AxisPlot_GUI;
cla(ax, 'reset');
if gui.flag.flag_data == 0
    title(ax, 'Import data first');
    return;
end

get_unit;
gui = guidata(gcf);
if isfield(gui.data, 'unloading') && isfield(gui.data.unloading, 'message')
    title(ax, ['Unloading unavailable: ', gui.data.unloading.message], ...
        'Interpreter', 'none');
    return;
elseif ~isfield(gui.data, 'unloading') || isempty(gui.data.unloading.P)
    title(ax, 'No unloading data available; reimport the data if needed');
    return;
end
data = gui.data.unloading;
if get(gui.handles.cb_SD_plot_GUI, 'Value') == 1
    gui.handles.plot_data = errorbar(ax, data.h, data.P, data.delta_P, 'rx-');
else
    gui.handles.plot_data = plot(ax, data.h, data.P, 'rx-');
end
xlabel(ax, ['Displacement ($h$) (', char(gui.data.dispUnit), ')'], ...
    'Interpreter', 'latex');
ylabel(ax, ['Load ($L$) (', char(gui.data.loadUnit), ')'], ...
    'Interpreter', 'latex');
title(ax, 'Measured unloading');
locations = listLocationLegend;
location = get(gui.handles.value_legend_location, 'Value');
legend(ax, 'Unloading', 'Location', char(locations(location)));
if get(gui.handles.cb_grid_plot_GUI, 'Value') == 1
    grid(ax, 'on');
else
    grid(ax, 'off');
end
if get(gui.handles.cb_log_plot_GUI, 'Value') == 1
    set(ax, 'XScale', 'log', 'YScale', 'log');
else
    set(ax, 'XScale', 'linear', 'YScale', 'linear');
end
set(ax, 'FontSize', 14);
guidata(gcf, gui);
end
