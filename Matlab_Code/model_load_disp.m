%% Copyright 2014 MERCIER David
function model_load_disp
%% Function used to analyze load-displacement curve
gui = guidata(gcf);

%% Energy calculation ==> Area below load-displacement curve
gui.results.W = 1e-6 * trapz(gui.data.h, gui.data.P); % in µJ / 1J=1N.m

%% Fit of the load-displacement curve
[k_fit, gui.results.P_fit, gui.results.fit] = load_displacement_fit(...
    gui.variables.loaddisp_model, gui.data.h, gui.data.P);
gui.results.fac_fit = k_fit(1);
gui.results.exp_fit = k_fit(2);

guidata(gcf, gui);

end