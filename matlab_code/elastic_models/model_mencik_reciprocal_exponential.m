%% Copyright 2014 MERCIER David
function model_mencik_reciprocal_exponential(OPTIONS)
%% Function used to calculate Young's modulus in bilayer system with
% the reciprocal exponential model of Mencik et al. (1997)
gui = guidata(gcf);

if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
    commandwindow;
    warning(['The correction of the thickness can''t be used ', ...
        'with Mencik''s reciprocal exponential model']);
end

x = gui.results.ac./gui.data.t;
x = checkValues(x);

% Minimum and maximum boundaries for the constant alpha
min_alpha = gui.config.numerics.alpha_min_Mencik;
max_alpha = gui.config.numerics.alpha_max_Mencik;

% A(1) = ln(abs(1/Ef-1/Es))
% A(2) = -alpha
bilayer_model = @(A, x) (A(1) + A(2)*x);

Es_red = gui.data.Es_red * 1e-9;
Esample_red = gui.results.Esample_red;
if ~isfinite(Es_red) || Es_red <= 0 || ...
        any(~isfinite(Esample_red(:)) | Esample_red(:) <= 0)
    error('NIMS:MencikReciprocal:InvalidModulus', ...
        'Substrate and measured reduced moduli must be finite and positive.');
end
delta_compliance = (1./Esample_red) - (1/Es_red);
if any(~isfinite(delta_compliance(:)))
    error('NIMS:MencikReciprocal:InvalidModulus', ...
        'The measured compliance contrast must be finite.');
end
if any(delta_compliance(:) == 0) || sum(delta_compliance(:)) == 0
    error('NIMS:MencikReciprocal:IndeterminateContrast', ...
        'The reciprocal exponential fit requires a nonzero modulus contrast.');
end
k = sign(sum(delta_compliance(:)));
log_delta_compliance = log(abs(delta_compliance));

% Make a starting guess
gui.results.A0 = [min(max(mean(log_delta_compliance(:)), -100), 100); ...
    (min_alpha + max_alpha)/2];

if gui.config.licenceOpt_Flag
    [gui.results.A, ...
        gui.results.resnorm, ...
        gui.results.residual, ...
        gui.results.exitflag, ...
        gui.results.output, ...
        gui.results.lambda, ...
        gui.results.jacobian] =...
        minimizationProcess(bilayer_model, gui.results.A0, x, ...
        log_delta_compliance, ...
        [-100 ; min_alpha], ...
        [100 ; max_alpha], ...
        OPTIONS);
else
    model = @LMS;
    gui.results.A = fminsearch(model, gui.results.A0, OPTIONS);
    warning('No Optimization toolbox available !');
end

    function [sse, FittedCurve] = LMS(params)
        A(1) = params(1);
        A(2) = params(2);
        FittedCurve = (A(1) + A(2)*x);
        gui.results.residual = FittedCurve - log_delta_compliance;
        sse = sum(gui.results.residual .^ 2);
    end

film_compliance = 1/Es_red + k * exp(gui.results.A(1));
if ~isfinite(film_compliance) || film_compliance <= 0
    error('NIMS:MencikReciprocal:InvalidFit', ...
        'The reciprocal exponential fit produced a nonpositive film compliance.');
end

gui.results.Ef_red_sol_fit(1) = 1/film_compliance;

% gui.results.A(2) = -alpha

gui.results.Em_red = (1/Es_red + ...
    (((1/gui.results.Ef_red_sol_fit(1)) - (1/Es_red)) .* ...
    exp(gui.results.A(2) .* x))).^-1;

gui.results.Ef_red(1:length(x)) = gui.results.Ef_red_sol_fit(1);
gui.results.Ef_red = gui.results.Ef_red';

guidata(gcf, gui);

end