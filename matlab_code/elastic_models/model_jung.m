%% Copyright 2014 MERCIER David
function model_jung(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the model of Jung et al. (2004)
gui = guidata(gcf);

x = gui.results.hc./gui.results.t_corr;
x = checkValues(x);

% Minimum and maximum boundaries for the constant alpha
A_Jung = gui.config.numerics.A_Jung;
B_Jung = gui.config.numerics.B_Jung;

L_Jung = sigmoidal_jung(x, A_Jung, B_Jung);

% A(1) = Ef_red
bilayer_model = @(A, x) ...
    (1e-9*(gui.data.Es_red * (1e9*A(1) ./ gui.data.Es_red)...
    .^L_Jung));

% Make a starting guess
gui.results.A0 = gui.data.Ef_red;

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
        gui.config.numerics.Min_YoungModulus, ...
        gui.config.numerics.Max_YoungModulus, ...
        OPTIONS);
else
    model = @LMS;
    gui.results.Ef_red_sol_fit = fminsearch(model, gui.results.A0);
    warning('No Optimization toolbox availble !');
end

    function [sse, FittedCurve] = LMS(params)
        A(1) = params(1);
        FittedCurve = (1e-9*(gui.data.Es_red * ...
            (1e9*A(1) ./ gui.data.Es_red).^L_Jung));
        ErrorVector = FittedCurve - gui.results.Esample_red;
        sse = sum(ErrorVector .^ 2);
    end

gui.results.Em_red = ...
    (1e-9*(gui.data.Es_red * (1e9*gui.results.Ef_red_sol_fit ./ gui.data.Es_red)...
    .^L_Jung));

gui.results.Ef_red = 1e-9*(((1e9.*gui.results.Esample_red)./...
    (1./gui.data.Es_red).^(L_Jung-1)).^(1./L_Jung));

guidata(gcf, gui);

end