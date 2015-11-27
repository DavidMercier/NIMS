%% Copyright 2014 MERCIER David
function model_doerner_nix_chen(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the model of Doerner & Nix (1986) modified by Chen (2004)
gui = guidata(gcf);

x = gui.results.t_corr./gui.results.ac;
x = checkValues(x);

% A(1) = Ef_red
% A(2) = alpha
bilayer_model = @(A, x) ...
    (1e-9*(((1./(1e9*A(1)))*(1-exp(-A(2)*x.^(2/3)))) + ...
    ((1./gui.data.Es_red)*(exp(-A(2)*x.^(2/3))))).^-1);

% Minimum and maximum boundaries for the constant alpha
min_alpha = gui.config.numerics.alpha_min_DoernerNix;
max_alpha = gui.config.numerics.alpha_max_DoernerNix;

% Make a starting guess
gui.results.A0 = [gui.data.Ef_red; (min_alpha + max_alpha)/2];

resultToolbox = isToolboxAvailable('Optimization Toolbox');

if resultToolbox
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
else
    model = @LMS;
    gui.results.Ef_red_sol_fit = fminsearch(model, gui.results.A0);
    warning('No Optimization toolbox available !');
end

    function [sse, FittedCurve] = LMS(params)
        A(1) = params(1);
        A(2) = params(2);
        FittedCurve = (1e-9*(((1./(1e9*A(1)))*(1-exp(-A(2)*x.^(2/3)))) + ...
            ((1./gui.data.Es_red)*(exp(-A(2)*x.^(2/3))))).^-1);
        ErrorVector = FittedCurve - gui.results.Esample_red;
        sse = sum(ErrorVector .^ 2);
    end

gui.results.Em_red = ...
    (1e-9*(((1./(1e9*gui.results.Ef_red_sol_fit(1)))*...
    (1-exp(-gui.results.Ef_red_sol_fit(2)*x.^(2/3)))) + ...
    ((1./gui.data.Es_red)*(exp(-gui.results.Ef_red_sol_fit(2)*x.^(2/3))))).^-1);

gui.results.Ef_red = 1e-9*(((1./(1e9.*gui.results.Esample_red)) - ...
    ((1./gui.data.Es_red)*(exp(-gui.results.Ef_red_sol_fit(2).*x.^(2/3)))))...
    ./(1-exp(-gui.results.Ef_red_sol_fit(2).*x.^(2/3)))).^-1;

guidata(gcf, gui);

end