%% Copyright 2014 MERCIER David
function model_load_disp
%% Function used to analyze load-displacement curve
gui = guidata(gcf);

%% Fit of the load-displacement curve
[k_fit, gui.results] = load_displacement_fit(...
    gui.variables.val2, gui.data.h, gui.data.P);
gui.results.fac_fit = k_fit(1);
gui.results.exp_fit = k_fit(2);

%% Energy calculation ==> Area below load-displacement curve
gui.results.W_microJ = 1e-6 * trapz(gui.data.h, gui.data.P); % in µJ / 1J=1N.m

gui.axis.legend2 = 'Polynomial Model';

guidata(gcf, gui);

end