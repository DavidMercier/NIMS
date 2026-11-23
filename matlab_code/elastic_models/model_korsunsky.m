function model_korsunsky(OPTIONS)
% Fit the four-parameter response to the stiffness-derived NIMS modulus.
gui = guidata(gcf);
thickness = gui.results.t_corr;
depth = gui.data.h;
measured = gui.results.Esample_red;
if ~isreal(thickness) || any(~isfinite(thickness(:)) | thickness(:) <= 0) || ...
        ~isvector(depth) || ~isreal(depth) || ...
        any(~isfinite(depth(:)) | depth(:) < 0) || ...
        ~isvector(measured) || ~isreal(measured) || ...
        numel(depth) ~= numel(measured) || ...
        (~isscalar(thickness) && numel(thickness) ~= numel(depth))
    error('NIMS:Korsunsky:InvalidData', ...
        'Matching depth and modulus vectors, finite nonnegative depths and positive thicknesses are required. If thickness correction is enabled, reduce the maximum depth or disable it.');
end
depth = depth(:);
measured = measured(:);
if ~isscalar(thickness)
    thickness = thickness(:);
end
x = depth ./ thickness;
fitMask = isfinite(measured) & measured > 0;
fitX = x(fitMask);
fitMeasured = measured(fitMask);
positiveX = fitX(fitX > 0);
if numel(unique(fitX)) < 4 || isempty(positiveX) || ...
        max(fitMeasured) - min(fitMeasured) <= eps(max(fitMeasured))
    error('NIMS:Korsunsky:IndeterminateFit', ...
        'At least four distinct depth ratios with finite positive, nonconstant moduli are required.');
end
if any(~fitMask)
    warning('NIMS:Korsunsky:InvalidSamples', ...
        'Excluded %d of %d samples with nonfinite or nonpositive reduced modulus from the Korsunsky fit.', ...
        sum(~fitMask), numel(fitMask));
end
[~, order] = sort(fitX);
initial = [fitMeasured(order(1)), fitMeasured(order(end)), median(positiveX), 1];
gui.results.A0 = initial;
model = @(logParameters, xdata) korsunsky_response(xdata, exp(logParameters));

if gui.config.licenceOpt_Flag
    [fit, gui.results.resnorm, gui.results.residual, gui.results.exitflag, ...
        gui.results.output, gui.results.lambda, gui.results.jacobian] = ...
        minimizationProcess(model, log(initial), fitX, fitMeasured, ...
        [], [], OPTIONS);
else
    options = optimset(OPTIONS, 'MaxFunEvals', 10000, 'MaxIter', 10000);
    [fit, gui.results.resnorm, gui.results.exitflag, gui.results.output] = ...
        fminsearch(@objective, log(initial), options);
    warning('NIMS:Korsunsky:NoOptimizationToolbox', ...
        'Using fminsearch because Optimization Toolbox is unavailable.');
end

parameters = exp(fit);
if any(~isfinite(parameters) | parameters <= 0)
    error('NIMS:Korsunsky:InvalidFit', 'The fitted parameters are not finite and positive.');
end
if gui.results.exitflag <= 0
    warning('NIMS:Korsunsky:FitDidNotConverge', ...
        'The Korsunsky fit did not converge; inspect the results before use.');
end
fitted = korsunsky_response(x, parameters);
gui.results.residual = fitted - measured;
gui.results.residual(~fitMask) = NaN;
gui.results.korsunsky_fit_mask = reshape(fitMask, size(gui.results.Esample_red));
gui.results.korsunsky_params = parameters;
gui.results.Ef_red_sol_fit = parameters(1:2);
gui.results.Em_red = reshape(fitted, size(gui.results.Esample_red));
gui.results.Ef_red = parameters(1) .* ones(size(gui.results.Esample_red));
guidata(gcf, gui);

    function sse = objective(logParameters)
        candidate = exp(logParameters);
        if any(~isfinite(candidate) | candidate <= 0)
            sse = Inf;
            return;
        end
        residual = korsunsky_response(fitX, candidate) - fitMeasured;
        sse = sum(residual .^ 2);
    end
end
