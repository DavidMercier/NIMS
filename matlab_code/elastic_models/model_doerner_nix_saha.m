%% Copyright 2014 MERCIER David
function model_doerner_nix_saha(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the model of Doerner & Nix (1986) modified by Saha (2002)
gui = guidata(gcf);

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
    commandwindow;
    warning(['The correction of the thickness can''t be used ', ...
        'with Saha''s model']);
end

% !!! Only with Oliver and Pharr model otherwise hc > t for some values
% x becomes negative... giving wrong values.

if get(gui.handles.value_modeldisp_GUI, 'Value') ~= 2
    set(gui.handles.value_modeldisp_GUI, 'Value', 2); % Oliver and Pharr
    gui.variables.val1 = get(gui.handles.value_modeldisp_GUI, 'Value');
    guidata(gcf, gui);
    model_function_area;
    gui = guidata(gcf); guidata(gcf, gui);
    commandwindow;
    warning(['Saha''s model can be only used with Oliver and Pharr''s ', ...
        'model !']);
end

x = (gui.data.t - gui.results.hc)./gui.results.ac;
x = checkValues(x);

% A(1) = Ef_red
% A(2) = alpha
bilayer_model = @(A, x) ...
    (1e-9*(((1./(1e9*A(1)))*(1-exp(-A(2)*x))) + ...
    ((1./gui.data.Es_red)*(exp(-A(2)*x)))).^-1);

% Minimum and maximum boundaries for the constant alpha
min_alpha = gui.config.numerics.alpha_min_DoernerNix;
max_alpha = gui.config.numerics.alpha_max_DoernerNix;

% Make a starting guess
gui.results.A0 = [gui.data.Ef_red; (min_alpha + max_alpha)/2];

[gui.results.Ef_red_sol_fit, ...
    gui.results.resnorm, ...
    gui.results.residual, ...
    gui.results.exitflag, ...
    gui.results.output, ...
    gui.results.lambda, ...
    gui.results.jacobian] =...
    minimizationProcess(bilayer_model, gui.results.A0, x, ...
    gui.results.Esample_red, ...
    [gui.config.numerics.Min_YoungModulus; min_alpha], ...
    [gui.config.numerics.Max_YoungModulus; max_alpha], ...
    OPTIONS);

gui.results.Em_red = ...
    (1e-9*(((1./(1e9*gui.results.Ef_red_sol_fit(1)))*...
    (1-exp(-gui.results.Ef_red_sol_fit(2)*x))) + ...
    ((1./gui.data.Es_red)*(exp(-gui.results.Ef_red_sol_fit(2)*x)))).^-1);

gui.results.Ef_red = 1e-9*(((1./(1e9.*gui.results.Esample_red)) - ...
    ((1./gui.data.Es_red)*(exp(-gui.results.Ef_red_sol_fit(2).*x))))./...
    (1-exp(-gui.results.Ef_red_sol_fit(2).*x))).^-1;

guidata(gcf, gui);

end