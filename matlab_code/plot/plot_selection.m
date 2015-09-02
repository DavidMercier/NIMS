%% Copyright 2014 MERCIER David
function plot_selection(plot2plot)
%% Function used to set plot
gui = guidata(gcf);

if plot2plot == 1
    get_and_plot;
elseif plot2plot == 2
    plot_residuals;
end

guidata(gcf, gui);

end