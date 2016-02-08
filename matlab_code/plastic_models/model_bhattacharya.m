%% Copyright 2014 MERCIER David
function model_bhattacharya(OPTIONS, n_BN)
%% Function used to calculate the hardness in bilayer sample with
% the model of Bhattacharya and Nix (1988).

gui = guidata(gcf);

t = gui.results.t_corr;
x = gui.results.hc./t;
x = checkValues(x);

% A(1) = Hf
% A(2) = alpha
bilayer_model = @(A, x) ...
    1e-9*(1e9.*gui.data.Hs + (1e9.*A(1) - 1e9.*gui.data.Hs) .* ...
    exp(-A(2) .* x.^n_BN));

% Minimum and maximum boundaries for the constant alpha
min_alpha = gui.config.numerics.alpha_min_BN;
max_alpha = gui.config.numerics.alpha_max_BN;

% Make a starting guess
gui.results.A0 = [gui.data.Hf0 ; (min_alpha + max_alpha)/2];

if gui.config.licenceOpt_Flag
    [gui.results.Hf_fit, ...
        gui.results.resnorm, ...
        gui.results.residual, ...
        gui.results.exitflag, ...
        gui.results.output, ...
        gui.results.lambda, ...
        gui.results.jacobian] =...
        lsqcurvefit(bilayer_model, gui.results.A0, x, ...
        gui.results.H, ...
        [gui.config.numerics.Min_Hardness ; min_alpha], ...
        [gui.config.numerics.Max_Hardness ; max_alpha], ...
        OPTIONS);
else
    model = @LMS;
    gui.results.Hf_fit = fminsearch(model, gui.results.A0, OPTIONS);
    warning('No Optimization toolbox available !');
end

    function [sse, FittedCurve] = LMS(params)
        A(1) = params(1);
        A(2) = params(2);
        FittedCurve = (1e-9*(1e9.*gui.data.Hs + (1e9.*A(1) - 1e9.*gui.data.Hs) ...
            .* exp(-A(2) .* x.^n_BN)));
        gui.results.residual = FittedCurve - gui.results.H;
        sse = sum(gui.results.residual .^ 2);
    end

gui.results.Hf = 1e-9*(1e9.*gui.data.Hs + (1e9.*gui.results.Hf_fit(1) ...
    - 1e9.*gui.data.Hs) .* exp(-gui.results.Hf_fit(2) .* x.^n_BN));

guidata(gcf, gui);

end