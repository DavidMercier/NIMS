function tests = test_mencik_reciprocal_exponential
tests = functiontests(localfunctions);
end

function testSoftAndStiffFilms(testCase)
for useToolbox = [false, true]
    if useToolbox && ~license('test', 'Optimization_Toolbox')
        continue;
    end
    for filmModulus = [50, 200]
        [fig, gui, options] = makeFixture(filmModulus, useToolbox);
        cleanup = onCleanup(@() close(fig));
        model_mencik_reciprocal_exponential(options);
        result = guidata(fig);
        verifyEqual(testCase, result.results.Ef_red_sol_fit(1), ...
            filmModulus, 'RelTol', 1e-5);
        verifyEqual(testCase, result.results.Em_red, ...
            gui.results.Esample_red, 'RelTol', 1e-5);
        clear cleanup;
    end
end
end

function testZeroContrastIsRejected(testCase)
[fig, gui, options] = makeFixture(100, false);
cleanup = onCleanup(@() close(fig));
verifyError(testCase, @() model_mencik_reciprocal_exponential(options), ...
    'NIMS:MencikReciprocal:IndeterminateContrast');
end

function testNonphysicalExtrapolationIsRejected(testCase)
for useToolbox = [false, true]
    if useToolbox && ~license('test', 'Optimization_Toolbox')
        continue;
    end
    [fig, gui, options] = makeFixture(200, useToolbox);
    cleanup = onCleanup(@() close(fig));
    x = gui.results.ac ./ gui.data.t;
    gui.results.Esample_red = 1 ./ (1/100 - 0.02 .* exp(-2 .* x));
    guidata(fig, gui);
    verifyError(testCase, @() model_mencik_reciprocal_exponential(options), ...
        'NIMS:MencikReciprocal:InvalidFit');
    clear cleanup;
end
end

function [fig, gui, options] = makeFixture(filmModulus, useToolbox)
fig = figure('Visible', 'off');
gui.handles.cb_corr_thickness_GUI = uicontrol(fig, 'Style', 'checkbox', 'Value', 0);
gui.data.t = 1;
gui.data.Es_red = 100e9;
gui.data.Ef_red = 60;
gui.results.ac = (0.4:0.1:1.4)';
x = gui.results.ac ./ gui.data.t;
gui.results.Esample_red = 1 ./ (1/100 + ...
    (1/filmModulus - 1/100) .* exp(-2 .* x));
gui.config.numerics.alpha_min_Mencik = -100;
gui.config.numerics.alpha_max_Mencik = 100;
gui.config.licenceOpt_Flag = useToolbox;
guidata(fig, gui);
options = optimset('Display', 'off', 'MaxFunEvals', 10000, ...
    'MaxIter', 10000, 'TolX', 1e-10, 'TolFun', 1e-12);
end
