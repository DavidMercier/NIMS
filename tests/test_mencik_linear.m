function tests = test_mencik_linear
tests = functiontests(localfunctions);
end

function testLinearFitWithOptimizationToolbox(testCase)
assumeTrue(testCase, license('test', 'Optimization_Toolbox') ~= 0);
fig = figure('Visible', 'off');
cleanup = onCleanup(@() close(fig));
gui.handles.cb_corr_thickness_GUI = uicontrol(fig, 'Style', 'checkbox', 'Value', 0);
gui.handles.value_youngsub_GUI = uicontrol(fig, 'Style', 'edit');
gui.data.t = 1;
gui.data.Es_red = 100e9;
gui.data.Ef_red = 60;
gui.results.ac = (0:0.1:0.9)';
x = gui.results.ac ./ gui.data.t;
gui.results.Esample_red = 50 + (100 - 50) .* x;
gui.config.numerics.Min_YoungModulus = 0;
gui.config.numerics.Max_YoungModulus = 1000;
gui.config.licenceOpt_Flag = true;
guidata(fig, gui);
options = optimset('Display', 'off', 'TolFun', 1e-12, 'TolX', 1e-10);

model_mencik_linear(options);
result = guidata(fig);
verifyEqual(testCase, result.results.A0, [60, 100]);
verifyEqual(testCase, result.results.Ef_red_sol_fit, [50, 100], 'AbsTol', 1e-5);
verifyEqual(testCase, result.results.Em_red, gui.results.Esample_red, 'AbsTol', 1e-5);
end
