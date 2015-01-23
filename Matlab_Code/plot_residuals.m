%% Copyright 2014 MERCIER David
function plot_residuals
%% Function used to plot residuals between experimental data and model
gui = guidata(gcf);

%% Initialization
set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI);
cla;

%% Normalization
residual_norm = gui.results.residual./gui.results.Esample_red;

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
xlabel(gui.axis.xlabelstr, 'Color', [0,0,0], 'FontSize', 14);
ylabel('Residuals / Young''s modulus of the sample (%)', 'Color', [0,0,0], 'FontSize', 14);
xlim([gui.axis.xmin gui.axis.xmax]);
ylim([min(residual_norm) max(residual_norm)]);
set(gui.handles.AxisPlot_GUI, 'FontSize', 14);
set(gui.handles.plot_data, 'MarkerSize', 10);
for ii = 1:length(gui.handles.plot_data)
    gui.handles.plot_data(ii).LineWidth = 2;
end

legend('Residuals / Young''s modulus of the sample', 'Location', 'NorthWest');
title('Residuals / Young''s modulus of the sample', 'FontSize', 18);

if get(gui.handles.cb_grid_plot_GUI, 'Value') == 1
    grid on;
else
    grid off;
end

guidata(gcf, gui);

end