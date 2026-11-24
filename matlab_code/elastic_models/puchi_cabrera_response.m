function [modulus, fractions] = puchi_cabrera_response(depth, thickness, moduli, model, parameters, poisson, halfAngle)
% Puchi-Cabrera et al. (2015), Eqs. 19-22 and Appendix 1.
% Films and their parameters are ordered from the surface to the substrate.
% moduli contains N film moduli followed by the substrate modulus, in one unit.
% parameters is N-by-1 (alpha), N-by-2 (beta, exponent), or [].
if nargin < 5
    parameters = [];
end
if nargin < 6
    poisson = [];
end
if nargin < 7
    halfAngle = 70.3;
end
if ~isnumeric(depth) || ~isreal(depth) || ~isvector(depth) || ...
        isempty(depth) || any(~isfinite(depth(:)) | depth(:) < 0) || ...
        ~isnumeric(thickness) || ~isreal(thickness) || ~isvector(thickness) || ...
        isempty(thickness) || any(~isfinite(thickness(:)) | thickness(:) <= 0) || ...
        ~isnumeric(moduli) || ~isreal(moduli) || ~isvector(moduli) || ...
        numel(moduli) ~= numel(thickness) + 1 || ...
        any(~isfinite(moduli(:)) | moduli(:) <= 0) || ...
        ~ischar(model) || ~isrow(model) || ...
        ~isnumeric(halfAngle) || ~isreal(halfAngle) || ~isscalar(halfAngle) || ...
        ~isfinite(halfAngle) || halfAngle <= 0 || halfAngle >= 90
    error('NIMS:PuchiCabrera:InvalidInput', ...
        'Nonnegative depths, positive film thicknesses and N+1 moduli, a model name, and a cone half-angle between 0 and 90 degrees are required.');
end
model = lower(model);
switch model
    case {'doerner_nix', 'mencik_1', 'mencik_2', 'antunes_1'}
        parameterCount = 1;
    case {'perriot_barthel', 'korsunsky_constantinescu'}
        parameterCount = 2;
    case {'gao', 'bec', 'antunes_2', 'bull'}
        parameterCount = 0;
    otherwise
        error('NIMS:PuchiCabrera:UnknownModel', 'Unknown model: %s.', model);
end
count = numel(thickness);
if ~isnumeric(parameters) || ~isreal(parameters) || ...
        (parameterCount == 0 && ~isempty(parameters)) || ...
        (parameterCount > 0 && (~isequal(size(parameters), [count, parameterCount]) || ...
        any(~isfinite(parameters(:)) | parameters(:) <= 0)))
    error('NIMS:PuchiCabrera:InvalidParameters', ...
        'This model requires %d positive empirical parameters per film (N-by-%d), or [] for a parameter-free model.', ...
        parameterCount, parameterCount);
end
if ismember(model, {'gao', 'antunes_2'}) && ...
        (~isnumeric(poisson) || ~isreal(poisson) || ~isvector(poisson) || ...
        numel(poisson) ~= count || any(~isfinite(poisson(:)) | poisson(:) <= -1 | poisson(:) >= 0.5))
    error('NIMS:PuchiCabrera:InvalidPoisson', ...
        'Gao and Antunes model 2 require one Poisson ratio between -1 and 0.5 per film.');
end
totalThickness = cumsum(thickness(:));
if any(~isfinite(totalThickness))
    error('NIMS:PuchiCabrera:InvalidInput', 'Cumulative film thicknesses must remain finite.');
end
cumulative = ones(numel(depth), count);
for layer = 1:count
    active = depth(:) > totalThickness(layer) / 100;
    q = (depth(active) - totalThickness(layer) / 100) ./ totalThickness(layer);
    q = q(:);
    switch model
        case {'doerner_nix', 'antunes_1'}
            weight = -expm1(-parameters(layer, 1) ./ q);
        case {'mencik_1', 'mencik_2'}
            weight = exp(-parameters(layer, 1) .* q);
        case {'bec', 'bull'}
            weight = 2 ./ (2 + pi .* q .* tan(halfAngle * pi / 180));
        case {'gao', 'antunes_2'}
            weight = gaoWeight(q .* tan(halfAngle * pi / 180), poisson(layer));
        case {'perriot_barthel', 'korsunsky_constantinescu'}
            logRatio = log(q) - log(parameters(layer, 1));
            if strcmp(model, 'perriot_barthel')
                logRatio = logRatio + log(tan(halfAngle * pi / 180));
            end
            weight = (1 - tanh(parameters(layer, 2) .* logRatio ./ 2)) ./ 2;
    end
    cumulative(active, layer) = weight;
end
fractions = [cumulative(:, 1), diff(cumulative, 1, 2), 1 - cumulative(:, end)];
if any(~isfinite(fractions(:)) | fractions(:) < -1e-12 | fractions(:) > 1 + 1e-12)
    error('NIMS:PuchiCabrera:InvalidFractions', ...
        'Layer weighting functions cross or produce nonphysical volume fractions. Revise the empirical parameters or Poisson ratios.');
end
% Remove roundoff only; physically negative fractions are rejected above.
fractions = max(fractions, 0);
fractions = bsxfun(@rdivide, fractions, sum(fractions, 2));
if ismember(model, {'doerner_nix', 'bec', 'mencik_2', 'antunes_2', 'bull'})
    result = 1 ./ (fractions * (1 ./ moduli(:)));
else
    result = fractions * moduli(:);
end
if any(~isfinite(result) | result <= 0)
    error('NIMS:PuchiCabrera:InvalidInput', 'The supplied moduli exceed the numerical range of the mixture law.');
end
modulus = reshape(result, size(depth));
end

function weight = gaoWeight(ratio, nu)
% Evaluate Eq. A2 without squaring large ratios or dividing by zero.
weight = ones(size(ratio));
weight(isinf(ratio)) = 0;
active = ratio > 0 & isfinite(ratio);
r = ratio(active);
term = zeros(size(r));
rational = zeros(size(r));
small = r <= 1;
term(small) = log1p(r(small).^2) ./ r(small);
rational(small) = r(small) ./ (1 + r(small).^2);
inverse = 1 ./ r(~small);
term(~small) = inverse .* (2 .* log(r(~small)) + log1p(inverse.^2));
rational(~small) = inverse ./ (1 + inverse.^2);
weight(active) = (2 / pi) .* atan(1 ./ r) + ...
    ((1 - 2 * nu) .* term - rational) ./ (2 * pi * (1 - nu));
end
