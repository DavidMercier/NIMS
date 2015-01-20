%% Copyright 2014 MERCIER David
function [k_fit, P_fit, results] = load_displacement_fit(model, h, P)
%% Function used to fit the loading part of the load-displacement curves

% Loubet J. L. et al., "Nanoindentation with a surface force apparatus.", (1993).
% http://dx.doi.org/10.1007/978-94-011-1765-4

% Hainsworth S.V. et al., "Analysis of nanoindentation load-displacement loading curves" (1996).
% http://dx.doi.org/10.1557/JMR.1996.0250

if model == 1
    load_disp_model = @(k, h) k(1) .* h.^k(2); % Fit with empirical power law. See in Loubet et al. (1986).
    k0 = [1e-5 1.5];  
    lb = [0, 1];
    ub = [1000, 3];
elseif model == 2
    load_disp_model = @(k, h) k .* h.^2; % Fit with empirical power law. See Hainsworth et al. (1996).
    k0 = 1e-5;
    lb = 0;
    ub = 1;
end

% Make a starting guess             
OPTIONS = optimset('lsqcurvefit');
OPTIONS = optimset(OPTIONS, 'TolFun',  1e-20);
OPTIONS = optimset(OPTIONS, 'TolX',    1e-20);
OPTIONS = optimset(OPTIONS, 'MaxIter', 10000);
[k_fit, results.resnorm, results.residual, results.exitflag, ...
    results.output, results.lambda, results.jacobian] =...
    lsqcurvefit(load_disp_model, k0, h, P, lb, ub, OPTIONS);

if model == 2
    k_fit(2) = 2;
end

P_fit = k_fit(1) .* h.^k_fit(2);

end