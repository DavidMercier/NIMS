function tests = test_puchi_cabrera
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(mfilename('fullpath')));
paths = {fullfile(repoRoot, 'matlab_code'), ...
    fullfile(repoRoot, 'matlab_code', 'elastic_models')};
existing = strsplit(path, pathsep);
testCase.TestData.addedPaths = paths(~ismember(paths, existing));
for ii = 1:numel(testCase.TestData.addedPaths)
    addpath(testCase.TestData.addedPaths{ii});
end
end

function teardownOnce(testCase)
for ii = 1:numel(testCase.TestData.addedPaths)
    rmpath(testCase.TestData.addedPaths{ii});
end
end

function testPublishedSingleFilmEquations(testCase)
models = modelNames;
q = 0.3;
radiusRatio = q * tan(70.3 * pi / 180);
nu = 0.3;
gao = (2 / pi) * atan(1 / radiusRatio) + ...
    ((1 - 2 * nu) * log(1 + radiusRatio^2) / radiusRatio - ...
    radiusRatio / (1 + radiusRatio^2)) / (2 * pi * (1 - nu));
weights = [1 - exp(-0.7 / q), gao, 2 / (2 + pi * radiusRatio), ...
    exp(-0.7 * q), exp(-0.7 * q), 1 / (1 + (radiusRatio / 2)^1.5), ...
    1 - exp(-0.7 / q), gao, 1 / (1 + (q / 2)^1.5), ...
    2 / (2 + pi * radiusRatio)];
for ii = 1:numel(models)
    parameters = weightingParameters(models{ii}, 1);
    if ~isempty(parameters)
        parameters(:, 1) = 0.7;
        if size(parameters, 2) == 2
            parameters = [2, 1.5];
        end
    end
    [actual, fractions] = puchi_cabrera_response(31, 100, [50, 200], ...
        models{ii}, parameters, nu);
    verifyEqual(testCase, fractions, [weights(ii), 1 - weights(ii)], 'AbsTol', 1e-13);
    if isHarmonic(models{ii})
        expected = 1 / (weights(ii) / 50 + (1 - weights(ii)) / 200);
    else
        expected = weights(ii) * 50 + (1 - weights(ii)) * 200;
    end
    verifyEqual(testCase, actual, expected, 'RelTol', 1e-13);
end
end

function testPublishedMultilayerDoernerNixEquation(testCase)
depth = [0, 1, 2, 3, 4, 6, 10, 100];
thickness = [100, 200, 300];
moduli = [50, 120, 70, 200];
alpha = [0.2; 0.3; 0.4];
total = cumsum(thickness);
cumulative = ones(numel(depth), 3);
for layer = 1:3
    active = depth > total(layer) / 100;
    cumulative(active, layer) = 1 - exp(-alpha(layer) * total(layer) ./ ...
        (depth(active) - total(layer) / 100));
end
expectedFractions = [cumulative(:, 1), diff(cumulative, 1, 2), 1 - cumulative(:, 3)];
[actual, fractions] = puchi_cabrera_response(depth, thickness, moduli, 'doerner_nix', alpha);
verifyEqual(testCase, fractions, expectedFractions, 'AbsTol', 1e-13);
verifyEqual(testCase, actual, reshape(1 ./ (expectedFractions * (1 ./ moduli')), ...
    size(depth)), 'RelTol', 1e-13);
end

function testThresholdsAndLimitsForEveryModel(testCase)
for count = [2, 3]
    thickness = [100, 200, 500];
    thickness = thickness(1:count);
    moduli = [50, 120, 70, 200];
    moduli = [moduli(1:count), moduli(end)];
    thresholds = cumsum(thickness) / 100;
    depth = [0, thresholds, thresholds * (1 + 1e-8), 1e12, 1e300];
    for model = modelNames
        name = model{1};
        parameters = weightingParameters(name, count);
        [actual, fractions] = puchi_cabrera_response(depth, thickness, moduli, ...
            name, parameters, 0.3 * ones(1, count));
        verifyEqual(testCase, actual(1:2), [50, 50], 'AbsTol', 1e-12);
        verifyEqual(testCase, fractions(count + 1, end), 0, 'AbsTol', 1e-12);
        verifyEqual(testCase, actual(end-1:end), [200, 200], 'AbsTol', 1e-6);
        verifyGreaterThanOrEqual(testCase, fractions, 0);
        verifyEqual(testCase, sum(fractions, 2), ones(numel(depth), 1), 'AbsTol', 1e-12);
        verifyEqual(testCase, fractions(2:count+1, :), ...
            fractions(count+2:2*count+1, :), 'AbsTol', 1e-6);
        column = puchi_cabrera_response(depth', thickness, moduli, ...
            name, parameters, 0.3 * ones(1, count));
        verifyEqual(testCase, column, actual', 'AbsTol', 1e-12);
    end
end
end

function testInvalidInputsAndCrossingFractions(testCase)
verifyError(testCase, @() puchi_cabrera_response(-1, 100, [50, 200], 'bec'), ...
    'NIMS:PuchiCabrera:InvalidInput');
verifyError(testCase, @() puchi_cabrera_response(1, 0, [50, 200], 'bec'), ...
    'NIMS:PuchiCabrera:InvalidInput');
verifyError(testCase, @() puchi_cabrera_response(1, 100, [50, NaN], 'bec'), ...
    'NIMS:PuchiCabrera:InvalidInput');
verifyError(testCase, @() puchi_cabrera_response(1, 100, [50, 200], 'unknown'), ...
    'NIMS:PuchiCabrera:UnknownModel');
verifyError(testCase, @() puchi_cabrera_response(1, 100, [50, 200], 'mencik_1'), ...
    'NIMS:PuchiCabrera:InvalidParameters');
verifyError(testCase, @() puchi_cabrera_response(1, 100, [50, 200], 'gao', [], 0.5), ...
    'NIMS:PuchiCabrera:InvalidPoisson');
verifyError(testCase, @() puchi_cabrera_response(100, [100, 100], [50, 100, 200], ...
    'doerner_nix', [10; 0.01]), 'NIMS:PuchiCabrera:InvalidFractions');
end

function testFitsAndInvertsTopFilmForEveryModel(testCase)
for count = [2, 3]
    for filmModulus = [50, 200]
        for model = modelNames
            name = model{1};
            [fig, gui] = fixture(count, filmModulus, name);
            cleanup = onCleanup(@() close(fig));
            model_puchi_cabrera(name);
            result = guidata(fig);
            verifyGreaterThan(testCase, result.results.exitflag, 0);
            verifyEqual(testCase, result.results.Ef_sol_fit, filmModulus, 'RelTol', 1e-6);
            verifyEqual(testCase, result.results.Em_red, gui.results.Esample_red, 'RelTol', 1e-6);
            verifyEqual(testCase, result.results.Ef_red, ...
                reduced_YM(filmModulus, 0.3) * ones(size(gui.data.h)), 'RelTol', 1e-6);
            verifyEqual(testCase, result.results.puchi_cabrera.volume_fractions, ...
                gui.expectedFractions, 'AbsTol', 1e-12);
            clear cleanup;
        end
    end
end
end

function testTopFilmModulusMayBeZeroBeforeFit(testCase)
for count = [2, 3]
    for model = {'bec', 'gao'}
        [fig, gui] = fixture(count, 50, model{1});
        cleanup = onCleanup(@() close(fig));
        if count == 2
            gui.data.E1 = 0;
        else
            gui.data.E2 = 0;
        end
        guidata(fig, gui);
        model_puchi_cabrera(model{1});
        result = guidata(fig);
        verifyEqual(testCase, result.results.Ef_sol_fit, 50, 'RelTol', 1e-6);
        verifyEqual(testCase, result.results.Em_red, gui.results.Esample_red, 'RelTol', 1e-6);
        clear cleanup;
    end
end
end

function testLowerLayerModulusMustBePositive(testCase)
[fig, gui] = fixture(2, 50, 'bec');
cleanup = onCleanup(@() close(fig));
gui.data.E0 = 0;
guidata(fig, gui);
verifyError(testCase, @() model_puchi_cabrera('bec'), 'NIMS:PuchiCabrera:InvalidInput');
end

function testInvalidSamplesAndInversions(testCase)
[fig, gui] = fixture(3, 50, 'bec');
cleanup = onCleanup(@() close(fig));
gui.results.Esample_red([1, 2]) = [NaN, -1];
guidata(fig, gui);
verifyWarning(testCase, @() model_puchi_cabrera('bec'), 'NIMS:PuchiCabrera:InvalidSamples');
result = guidata(fig);
verifyEqual(testCase, result.results.Ef_sol_fit, 50, 'RelTol', 1e-6);
verifyTrue(testCase, all(isnan(result.results.Ef_red([1, 2]))));
verifyTrue(testCase, all(isnan(result.results.residual([1, 2]))));
verifyEqual(testCase, size(result.results.Em_red), size(gui.data.h));

gui.results.Esample_red = result.results.Em_red;
gui.results.Esample_red(end) = 1e6;
guidata(fig, gui);
verifyWarning(testCase, @() model_puchi_cabrera('bec'), 'NIMS:PuchiCabrera:InvalidInversion');
result = guidata(fig);
verifyTrue(testCase, isnan(result.results.Ef_red(end)));
verifyTrue(testCase, all(isfinite(result.results.Ef_red(1:end-1))));

gui.results.Esample_red(:) = NaN;
guidata(fig, gui);
verifyError(testCase, @() model_puchi_cabrera('bec'), 'NIMS:PuchiCabrera:IndeterminateFit');
end

function testThicknessCorrectionIsExplicitlyIgnored(testCase)
[fig, gui] = fixture(2, 50, 'bec');
cleanup = onCleanup(@() close(fig));
set(gui.handles.cb_corr_thickness_GUI, 'Value', 1);
verifyWarning(testCase, @() model_puchi_cabrera('bec'), ...
    'NIMS:PuchiCabrera:ThicknessCorrectionIgnored');
result = guidata(fig);
verifyEqual(testCase, result.results.Ef_sol_fit, 50, 'RelTol', 1e-6);
end

function [fig, gui] = fixture(count, filmModulus, model)
fig = figure('Visible', 'off');
gui.handles.cb_corr_thickness_GUI = uicontrol(fig, 'Style', 'checkbox', 'Value', 0);
gui.variables.num_thinfilm = count + 1;
gui.data.h = logspace(0, 3, 40);
gui.data.t0 = 500;
gui.data.t1 = 200;
gui.data.t2 = 100;
gui.data.E0 = 70e9;
gui.data.E1 = 120e9;
gui.data.E2 = 90e9;
gui.data.Es = 150e9;
gui.data.nuf0 = 0.3;
gui.data.nuf1 = 0.3;
gui.data.nuf2 = 0.3;
gui.data.nus = 0.3;
gui.data.nuf = 0.3;
gui.data.indenter_tip_angle = '70.3';
if count == 2
    thickness = [gui.data.t1, gui.data.t0];
    moduli = [filmModulus, 70, 150];
else
    thickness = [gui.data.t2, gui.data.t1, gui.data.t0];
    moduli = [filmModulus, 120, 70, 150];
end
[gui.results.Esample_red, gui.expectedFractions] = ...
    puchi_cabrera_response(gui.data.h, thickness, reduced_YM(moduli, 0.3), ...
    model, weightingParameters(model, count), 0.3 * ones(1, count));
gui.config.numerics = struct('Min_YoungModulus', 0, 'Max_YoungModulus', 1000, ...
    'TolX_value', 1e-10, 'MaxIter_value', 10000);
guidata(fig, gui);
end

function parameters = weightingParameters(model, count)
switch model
    case {'doerner_nix', 'mencik_1', 'mencik_2', 'antunes_1'}
        parameters = ones(count, 1);
    case {'perriot_barthel', 'korsunsky_constantinescu'}
        parameters = ones(count, 2);
    otherwise
        parameters = [];
end
end

function harmonic = isHarmonic(model)
harmonic = ismember(model, {'doerner_nix', 'bec', 'mencik_2', 'antunes_2', 'bull'});
end

function models = modelNames
models = {'doerner_nix', 'gao', 'bec', 'mencik_1', 'mencik_2', ...
    'perriot_barthel', 'antunes_1', 'antunes_2', 'korsunsky_constantinescu', 'bull'};
end
