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
plot(gui.axis.x2plot, residual_norm, 'rx', 'LineWidth', 2);
legend('Residuals / Young''s modulus of the sample', 'Location', 'NorthWest');
title('Residuals / Young''s modulus of the sample', 'FontSize', 18);

%% Plot properties
xlabel(gui.axis.xlabelstr, 'Color', [0,0,0]);
ylabel('Residuals / Young''s modulus of the sample (%)', 'Color', [0,0,0]);
xlim([gui.axis.xmin gui.axis.xmax]);
ylim([min(residual_norm) max(residual_norm)]);
grid on;

guidata(gcf, gui);

end
