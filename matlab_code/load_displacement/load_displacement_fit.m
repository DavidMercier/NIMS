%% Copyright 2014 MERCIER David
function [k_fit, results] = load_displacement_fit(modelFit, h, P)
%% Function used to fit the loading part of the load-displacement curves

% Loubet J. L. et al., "Nanoindentation with a surface force apparatus.", (1993).
% http://dx.doi.org/10.1007/978-94-011-1765-4

% Hainsworth S.V. et al., "Analysis of nanoindentation load-displacement loading curves" (1996).
% http://dx.doi.org/10.1557/JMR.1996.0250

gui = guidata(gcf);

if modelFit ~= 1
    if modelFit == 2
        load_disp_model = @(k, h) k(1) .* h.^k(2); % Fit with empirical power law. See in Loubet et al. (1986).
        k0 = [1e-5 1.5];
        lb = [0, 1];
        ub = [1000, 3];
        % Make a starting guess
        if gui.config.licenceFlag
            OPTIONS = optimset('lsqcurvefit');
            OPTIONS = optimset(OPTIONS, 'TolFun',  1e-20);
            OPTIONS = optimset(OPTIONS, 'TolX',    1e-20);
            OPTIONS = optimset(OPTIONS, 'MaxIter', 10000);
            [k_fit, results.resnorm, results.residual, results.exitflag, ...
                results.output, results.lambda, results.jacobian] =...
                lsqcurvefit(load_disp_model, k0, h, P, lb, ub, OPTIONS);
        else
            model = @LMS1;
            k_fit = fminsearch(model, k0);
            warning('No Optimization toolbox available !');
        end
    elseif modelFit == 3
        load_disp_model = @(k, h) k .* h.^2; % Fit with empirical power law. See Hainsworth et al. (1996).
        k0 = 1e-5;
        lb = 0;
        ub = 1;
        % Make a starting guess
        if gui.config.licenceFlag
            OPTIONS = optimset('lsqcurvefit');
            OPTIONS = optimset(OPTIONS, 'TolFun',  1e-20);
            OPTIONS = optimset(OPTIONS, 'TolX',    1e-20);
            OPTIONS = optimset(OPTIONS, 'MaxIter', 10000);
            [k_fit, results.resnorm, results.residual, results.exitflag, ...
                results.output, results.lambda, results.jacobian] =...
                lsqcurvefit(load_disp_model, k0, h, P, lb, ub, OPTIONS);
        else
            model = @LMS2;
            k_fit = fminsearch(model, k0);
            warning('No Optimization toolbox available !');
        end
    end
    if modelFit == 3
        k_fit(2) = 2;
    end
    
    results.P_fit = k_fit(1) .* h.^k_fit(2);
    results.rSquare = r_square(P, results.P_fit);
else
    k_fit = [0, 0];
    results.P_fit = 0;
    results.residual = 0;
    results.rSquare = 0;
end

    function [sse, FittedCurve] = LMS1(params)
        A(1) = params(1);
        A(2) = params(2);
        FittedCurve = A(1) .* h.^A(2);
        ErrorVector = FittedCurve - P;
        sse = sum(ErrorVector .^ 2);
    end

    function [sse, FittedCurve] = LMS2(params)
        A(1) = params(1);
        FittedCurve = A(1) .* h.^2;
        ErrorVector = FittedCurve - P;
        sse = sum(ErrorVector .^ 2);
    end

end