function model_puchi_cabrera(model)
% Fit only the top-film reduced modulus; lower layers and weights stay fixed.
gui = guidata(gcf);
if gui.variables.num_thinfilm == 3
    thickness = [gui.data.t1, gui.data.t0];
    moduli = [gui.data.E1, gui.data.E0, gui.data.Es] .* 1e-9;
    poisson = [gui.data.nuf1, gui.data.nuf0, gui.data.nus];
elseif gui.variables.num_thinfilm == 4
    thickness = [gui.data.t2, gui.data.t1, gui.data.t0];
    moduli = [gui.data.E2, gui.data.E1, gui.data.E0, gui.data.Es] .* 1e-9;
    poisson = [gui.data.nuf2, gui.data.nuf1, gui.data.nuf0, gui.data.nus];
else
    error('NIMS:PuchiCabrera:InvalidStack', 'Select two or three films on a substrate.');
end
if any(~isfinite(poisson) | poisson <= -1 | poisson >= 0.5)
    error('NIMS:PuchiCabrera:InvalidPoisson', 'Every material requires a Poisson ratio between -1 and 0.5.');
end
moduli = reduced_YM(moduli, poisson);
% The top-film modulus is fitted; only the fractions are needed here.
moduli(1) = 1;
switch model
    case {'doerner_nix', 'mencik_1', 'mencik_2', 'antunes_1'}
        parameters = ones(numel(thickness), 1);
    case {'perriot_barthel', 'korsunsky_constantinescu'}
        parameters = ones(numel(thickness), 2);
    otherwise
        parameters = [];
end
halfAngle = str2double(gui.data.indenter_tip_angle);
[~, fractions] = puchi_cabrera_response(gui.data.h, thickness, moduli, ...
    model, parameters, poisson(1:end-1), halfAngle);
measured = gui.results.Esample_red;
if ~isnumeric(measured) || ~isreal(measured) || ~isvector(measured) || ...
        numel(measured) ~= numel(gui.data.h)
    error('NIMS:PuchiCabrera:InvalidInput', 'Depth and measured reduced modulus must be matching vectors.');
end
measured = measured(:);
fitMask = isfinite(measured) & measured > 0;
if ~any(fitMask & fractions(:, 1) > eps)
    error('NIMS:PuchiCabrera:IndeterminateFit', ...
        'No finite positive modulus measurements have a resolvable top-film contribution.');
end
if any(~fitMask)
    warning('NIMS:PuchiCabrera:InvalidSamples', ...
        'Excluded %d nonfinite or nonpositive modulus measurements from the fit.', sum(~fitMask));
end
if get(gui.handles.cb_corr_thickness_GUI, 'Value') == 1
    warning('NIMS:PuchiCabrera:ThicknessCorrectionIgnored', ...
        'Puchi-Cabrera models use nominal thicknesses and the published 1%% onset shift; the additional thickness correction is not applied.');
end
harmonic = ismember(model, {'doerner_nix', 'bec', 'mencik_2', 'antunes_2', 'bull'});
if harmonic
    lowerContribution = fractions(:, 2:end) * (1 ./ moduli(2:end)');
else
    lowerContribution = fractions(:, 2:end) * moduli(2:end)';
end
fitWeight = fractions(fitMask, 1);
fitLower = lowerContribution(fitMask);
fitMeasured = measured(fitMask);
if harmonic
    response = @(topModulus) 1 ./ (fractions(:, 1) ./ topModulus + lowerContribution);
    objective = @(topModulus) sum((1 ./ (fitWeight ./ topModulus + fitLower) - fitMeasured).^2);
else
    response = @(topModulus) fractions(:, 1) .* topModulus + lowerContribution;
    objective = @(topModulus) sum((fitWeight .* topModulus + fitLower - fitMeasured).^2);
end
lower = gui.config.numerics.Min_YoungModulus;
upper = gui.config.numerics.Max_YoungModulus;
if ~isscalar(lower) || ~isscalar(upper) || ~isfinite(lower) || ...
        ~isfinite(upper) || lower < 0 || upper <= lower
    error('NIMS:PuchiCabrera:InvalidBounds', 'Modulus bounds must be finite with 0 <= minimum < maximum.');
end
options = optimset('Display', 'off', 'TolX', gui.config.numerics.TolX_value, ...
    'MaxIter', gui.config.numerics.MaxIter_value, ...
    'MaxFunEvals', gui.config.numerics.MaxIter_value);
[fit, gui.results.resnorm, gui.results.exitflag, gui.results.output] = ...
    fminbnd(objective, lower, upper, options);
if ~isfinite(fit) || fit <= 0 || ~isfinite(gui.results.resnorm)
    error('NIMS:PuchiCabrera:InvalidFit', ...
        'The fitted top-film modulus must be finite and positive, with a finite residual norm.');
end
if gui.results.exitflag <= 0
    warning('NIMS:PuchiCabrera:FitDidNotConverge', ...
        'The top-film fit did not converge; inspect the results before use.');
end
fitted = response(fit);
if harmonic
    inverse = 1 ./ measured - lowerContribution;
    film = fractions(:, 1) ./ inverse;
    valid = fitMask & fractions(:, 1) > eps & inverse > 0;
else
    film = (measured - lowerContribution) ./ fractions(:, 1);
    valid = fitMask & fractions(:, 1) > eps & film > 0;
end
valid = valid & isfinite(film);
film(~valid) = NaN;
if any(fitMask & ~valid)
    warning('NIMS:PuchiCabrera:InvalidInversion', ...
        'Excluded %d nonphysical or unresolved pointwise top-film estimates.', sum(fitMask & ~valid));
end
gui.results.Ef_red_sol_fit = fit;
gui.results.Ef_sol_fit = non_reduced_YM(fit, gui.data.nuf);
gui.results.Em_red = reshape(fitted, size(gui.results.Esample_red));
gui.results.Ef_red = reshape(film, size(gui.results.Esample_red));
gui.results.residual = gui.results.Em_red - gui.results.Esample_red;
gui.results.residual(~reshape(fitMask, size(gui.results.Esample_red))) = NaN;
gui.results.puchi_cabrera = struct('model', model, 'parameters', parameters, ...
    'volume_fractions', fractions, 'fit_mask', reshape(fitMask, size(gui.results.Esample_red)), ...
    'fitted_top_young_modulus_GPa', gui.results.Ef_sol_fit, ...
    'fitted_top_reduced_modulus_GPa', fit);
gui.axis.legend2 = 'Puchi-Cabrera model (fixed weights, nominal thickness)';
guidata(gcf, gui);
end
