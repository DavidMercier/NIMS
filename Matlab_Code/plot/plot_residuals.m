%% Copyright 2014 MERCIER David
function plot_residuals
%% Function used to plot residuals between experimental data and model
gui = guidata(gcf);

%% Initialization
set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
cla;

if ~isfield(gui.results, 'residual')
    gui.results.residual = 0;
end

%% Normalization
if gui.variables.y_axis == 1
    residual_norm = gui.results.residual./gui.data.P;
    gui.axis.legend_str = 'Residuals / Load';
    gui.axis.title_str = 'Residuals / Load';
    gui.axis.ylabelstr = 'Residuals / Load (%)';
elseif gui.variables.y_axis > 3
    residual_norm = gui.results.residual./gui.results.Esample_red;
    gui.axis.legend_str = 'Residuals / Young''s modulus of the sample';
    gui.axis.title_str = 'Residuals / Young''s modulus of the sample';
    gui.axis.ylabelstr = 'Residuals / Young''s modulus of the sample (%)';
end

%% Setting of the plot
if gui.variables.x_axis == 1
    gui.axis.x2plot = gui.data.h;
    gui.axis.xlabelstr = 'Displacement (nm)';
    gui.axis.xmax = round(max(gui.data.h));
    gui.axis.xmin = 0;
    
elseif gui.variables.x_axis == 2
    gui.axis.x2plot = gui.results.ac./gui.data.t;
    gui.axis.xlabelstr = 'Contact Radius/Film Thickness';
    gui.axis.xmax = round(max(gui.results.ac./gui.data.t));
    gui.axis.xmin = round(min(gui.results.ac./gui.data.t));
    
elseif gui.variables.x_axis == 3
    gui.axis.x2plot = gui.data.h/gui.data.t;
    gui.axis.xlabelstr = 'Displ./Film Thickness';
    gui.axis.xmax = round(max(gui.data.h/gui.data.t));
    gui.axis.xmin = 0;
    
end

%% Definiton of the plot
if gui.variables.log_plot_value == 0
    gui.handles.plot_data = ...
        plot(gui.axis.x2plot, residual_norm, 'rx', 'LineWidth', 2);
elseif gui.variables.log_plot_value == 1
    gui.handles.plot_data = ...
        loglog(gui.axis.x2plot, residual_norm, 'rx', 'LineWidth', 2);
end
%% Plot properties
gui.axis.ymin = min(residual_norm);
gui.axis.ymax = max(residual_norm);
if max(residual_norm) == min(residual_norm)
    gui.axis.ymin = min(residual_norm) - 1;
    gui.axis.ymax = max(residual_norm) + 1;
end

set(gui.handles.pb_residual_plot_GUI, 'string', 'Plot');
set(gui.handles.pb_residual_plot_GUI, 'Callback', 'plot_selection(1)');

guidata(gcf, gui);

plot_properties;

end