function tests = test_korsunsky
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
repoRoot = fileparts(fileparts(mfilename('fullpath')));
codePath = fullfile(repoRoot, 'matlab_code');
paths = {codePath, fullfile(codePath, 'elastic_models')};
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

function testResponseLimits(testCase)
for parameters = {[50, 200, 0.2, 1.5], [200, 50, 0.2, 1.5]}
    p = parameters{1};
    actual = korsunsky_response([0, p(3), 1e12], p);
    verifyEqual(testCase, actual(1), p(1), 'AbsTol', 1e-12);
    verifyEqual(testCase, actual(2), (p(1) + p(2)) / 2, 'AbsTol', 1e-12);
    verifyEqual(testCase, actual(3), p(2), 'AbsTol', 1e-10);
end
verifyError(testCase, @() korsunsky_response(-1, [1, 2, 1, 1]), ...
    'NIMS:Korsunsky:InvalidInput');
end

function testFitSyntheticCurves(testCase)
for useToolbox = [false, true]
    if useToolbox && ~license('test', 'Optimization_Toolbox')
        continue;
    end
    for parameters = {[50, 200, 0.2, 1.5], [200, 50, 0.2, 1.5]}
        p = parameters{1};
        [fig, gui, options] = fixture(p, useToolbox);
        cleanup = onCleanup(@() close(fig));
        model_korsunsky(options);
        result = guidata(fig);
        verifyGreaterThan(testCase, result.results.exitflag, 0);
        verifyEqual(testCase, result.results.korsunsky_params, p, 'RelTol', 1e-4);
        verifyEqual(testCase, result.results.Em_red, gui.results.Esample_red, 'AbsTol', 1e-4);
        verifyEqual(testCase, result.results.Ef_red, ...
            p(1) .* ones(size(gui.results.Esample_red)), 'AbsTol', 1e-3);
        clear cleanup;
    end
end
end

function testInvalidAndIndeterminateInputs(testCase)
[fig, gui, options] = fixture([50, 200, 0.2, 1.5], false);
cleanup = onCleanup(@() close(fig));
gui.results.t_corr = 0;
guidata(fig, gui);
verifyError(testCase, @() model_korsunsky(options), 'NIMS:Korsunsky:InvalidData');
gui.results.t_corr = 1;
gui.results.Esample_red(:) = 100;
guidata(fig, gui);
verifyError(testCase, @() model_korsunsky(options), 'NIMS:Korsunsky:IndeterminateFit');
end

function testExcludesInvalidModuliWithoutDroppingCurvePoints(testCase)
p = [50, 200, 0.2, 1.5];
[fig, gui, options] = fixture(p, false);
cleanup = onCleanup(@() close(fig));
gui.results.Esample_red([1, 3]) = [-1070, NaN];
guidata(fig, gui);
warningState = warning('off', 'NIMS:Korsunsky:NoOptimizationToolbox');
restoreWarning = onCleanup(@() warning(warningState));
verifyWarning(testCase, @() model_korsunsky(options), 'NIMS:Korsunsky:InvalidSamples');
result = guidata(fig);
verifyEqual(testCase, result.results.korsunsky_params, p, 'RelTol', 1e-4);
verifyEqual(testCase, size(result.results.Em_red), size(gui.results.Esample_red));
verifyFalse(testCase, any(result.results.korsunsky_fit_mask([1, 3])));
verifyTrue(testCase, all(isnan(result.results.residual([1, 3]))));

gui.results.Esample_red(:) = NaN;
gui.results.Esample_red(1:3) = [50, 60, 70];
guidata(fig, gui);
verifyError(testCase, @() model_korsunsky(options), 'NIMS:Korsunsky:IndeterminateFit');
end

function [fig, gui, options] = fixture(parameters, useToolbox)
fig = figure('Visible', 'off');
gui.data.h = logspace(-3, 1, 60)';
gui.results.t_corr = 1;
gui.results.Esample_red = korsunsky_response(gui.data.h, parameters);
gui.config.licenceOpt_Flag = useToolbox;
guidata(fig, gui);
options = optimset('Display', 'off', 'MaxFunEvals', 10000, ...
    'MaxIter', 10000, 'TolX', 1e-10, 'TolFun', 1e-12);
end
