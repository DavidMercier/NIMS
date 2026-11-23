function tests = test_elastic_model_comparison
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
demo;
fig = gcf;
testCase.TestData.fig = fig;
gui = guidata(fig);
file = fullfile(gui.config.NIMSroot, 'data_indentation', ...
    'MTS_1film_SiO2_Si_CSM-2nm.xls');
[~, ~, raw] = xlsread(file);
boundary = find(strcmp(raw(:,1), 'Hold Segment Type') | ...
    strcmp(raw(:,1), 'Unload From Peak Segment Type'), 1);
[data, units] = mts_segment_data(raw, boundary - 1);
gui.data.h_init = data(:,1);
gui.data.delta_h_init = data(:,2);
gui.data.P_init = data(:,3);
gui.data.delta_P_init = data(:,4);
gui.data.S_init = data(:,5);
gui.data.delta_S_init = data(:,6);
gui.flag.flag_data = 1;
gui.flag.flag_no_csm = 0;
guidata(fig, gui);
set_unit(fig, units);
set(gui.handles.value_mindepth_GUI, 'String', num2str(round(min(data(:,1)))));
set(gui.handles.value_maxdepth_GUI, 'String', num2str(round(max(data(:,1)))));
set(gui.handles.value_youngsub_GUI, 'String', '165');
set(gui.handles.value_youngfilm0_GUI, 'String', '60');
set(gui.handles.value_numthinfilm_GUI, 'Value', 2);
set(gui.handles.value_param2plotinyaxis_GUI, 'Value', 4);
figure(fig);
get_and_plot;
end

function testKorsunskyModelSelection(testCase)
fig = testCase.TestData.fig;
figure(fig);
gui = guidata(fig);
set(gui.handles.value_numthinfilm_GUI, 'Value', 2);
set(gui.handles.value_param2plotinyaxis_GUI, 'Value', 4);
set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
set(gui.handles.value_youngfilm0_GUI, 'String', '60');
set(gui.handles.value_elastic_models_GUI, 'Value', 14);
get_and_plot;
gui = guidata(fig);
verifyEqual(testCase, numel(gui.results.korsunsky_params), 4);
verifyEqual(testCase, gui.axis.y2plot_2, gui.results.Em_red);
verifyEqual(testCase, get(gui.handles.value_youngfilm0_GUI, 'String'), '60');
verifyNotEmpty(testCase, strfind(gui.axis.title_str, 'Korsunsky fit'));

set(gui.handles.value_elastic_models_GUI, 'Value', [6 14]);
get_and_plot;
gui = guidata(fig);
verifyEqual(testCase, gui.results.elastic_comparison{2}.name, ...
    'Korsunsky_Constantinescu_2009');
verifyEqual(testCase, numel(gui.results.elastic_comparison{2}.korsunsky_params), 4);
verifyNotEmpty(testCase, strfind(gui.axis.legend_str{3}, 'shallow asymptote'));
end

function teardownOnce(testCase)
if isgraphics(testCase.TestData.fig)
    delete(testCase.TestData.fig);
end
end

function testComparisonAndModeTransitions(testCase)
fig = testCase.TestData.fig;
figure(fig);
gui = guidata(fig);
verifyEqual(testCase, char(get(gui.handles.value_elastic_models_GUI, 'Visible')), 'on');
set(gui.handles.value_elastic_models_GUI, 'Value', 6);
get_and_plot;
gui = guidata(fig);
expected = gui.results.Em_red;

set(gui.handles.value_youngfilm0_GUI, 'String', '60');
set(gui.handles.value_youngsub_GUI, 'String', '165');
set(gui.handles.cb_corr_thickness_GUI, 'Value', 1);
set(gui.handles.value_elastic_models_GUI, 'Value', [6 11]);
get_and_plot;
gui = guidata(fig);
verifyEqual(testCase, numel(gui.results.elastic_comparison), 2);
verifyEqual(testCase, gui.results.elastic_comparison{1}.name, 'Gao_etal.');
verifyEqual(testCase, gui.results.elastic_comparison{2}.name, 'Mencik_etal._linear');
verifyEqual(testCase, get(gui.handles.value_youngsub_GUI, 'String'), '165');
verifyEqual(testCase, get(gui.handles.value_youngfilm0_GUI, 'String'), '60');
verifyEqual(testCase, get(gui.handles.cb_corr_thickness_GUI, 'Value'), 1);
verifyEqual(testCase, char(get(gui.handles.pb_residual_plot_GUI, 'Visible')), 'off');
verifyNotEmpty(testCase, strfind(gui.axis.legend_str{3}, 'no thickness correction'));
verifyEqual(testCase, numel(gui.axis.legend_str), 3);
curves = findobj(gui.handles.AxisPlot_GUI, 'Type', 'line');
for ii = 1:2
    expected_curve = gui.results.elastic_comparison{ii}.Em_red;
    matches = arrayfun(@(line) isequal(reshape(get(line, 'YData'), [], 1), ...
        expected_curve(:)), curves);
    verifyTrue(testCase, any(matches));
end

set(gui.handles.cb_corr_thickness_GUI, 'Value', 0);
get_and_plot;
gui = guidata(fig);
verifyEqual(testCase, gui.results.elastic_comparison{1}.Em_red, expected, 'RelTol', 1e-8);
set(gui.handles.value_param2plotinyaxis_GUI, 'Value', 5);
get_and_plot;
gui = guidata(fig);
verifyEqual(testCase, get(gui.handles.value_elastic_models_GUI, 'Value'), [6 11]);
verifyEqual(testCase, gui.axis.y2plot_2, gui.results.elastic_comparison{1}.Ef_red);

set(gui.handles.value_param2plotinyaxis_GUI, 'Value', 6);
get_and_plot;
gui = guidata(fig);
verifyEqual(testCase, char(get(gui.handles.value_elastic_models_GUI, 'Visible')), 'off');
verifyEqual(testCase, char(get(gui.handles.value_model_GUI, 'Visible')), 'on');
verifyEqual(testCase, get(gui.handles.value_model_GUI, 'Value'), 1);
end

function testDirectHardnessPlot(testCase)
fig = testCase.TestData.fig;
figure(fig);
gui = guidata(fig);
set(gui.handles.value_numthinfilm_GUI, 'Value', 2);
set(gui.handles.value_param2plotinyaxis_GUI, 'Value', 6);
set(gui.handles.value_param2plotinxaxis_GUI, 'Value', 1);
get_and_plot;
gui = guidata(fig);
set(gui.handles.value_param2plotinxaxis_GUI, 'Value', 4);
get_and_plot;
gui = guidata(fig);
verifyEqual(testCase, gui.axis.title_str, 'Select a film and a hardness model');
verifyEqual(testCase, get(gui.handles.cb_SD_plot_GUI, 'Enable'), 'off');
verifyEqual(testCase, get(gui.handles.cb_lines_plot_GUI, 'Enable'), 'off');
verifyEqual(testCase, get(gui.handles.pb_residual_plot_GUI, 'Visible'), 'off');

set(gui.handles.value_model_GUI, 'Value', 2);
get_and_plot;
gui = guidata(fig);
sample = gui.results.H(:);
valid = isfinite(sample) & sample >= 0;
verifyEqual(testCase, gui.axis.x2plot, sample(valid));
verifyEqual(testCase, gui.axis.y2plot, ...
    repmat(gui.results.Hf_fit(1), size(gui.axis.x2plot)));
verifyEqual(testCase, gui.axis.legend_str, 'Fitted film hardness (constant)');

gui.variables.val2 = 6;
gui.results.H = [2, 3, NaN, 4];
gui.results.Hf = [4, 8, 2, -1];
guidata(fig, gui);
verifyWarning(testCase, @plot_exp_vs_mod, 'NIMS:HardnessPlot:InvalidSamples');
gui = guidata(fig);
verifyEqual(testCase, reshape(get(gui.handles.plot_data, 'XData'), 1, []), [2, 3]);
verifyEqual(testCase, reshape(get(gui.handles.plot_data, 'YData'), 1, []), [4, 8]);

gui.variables.val2 = 3;
gui.results.H = [2, 3, 4];
gui.results.Hf_fit = [5, 2];
gui.results.Hf = [7, 8, 9];
guidata(fig, gui);
plot_exp_vs_mod;
gui = guidata(fig);
verifyEqual(testCase, reshape(get(gui.handles.plot_data, 'YData'), 1, []), [5, 5, 5]);
verifyEqual(testCase, gui.axis.legend_str, 'Fitted film hardness (constant)');

set(gui.handles.value_param2plotinyaxis_GUI, 'Value', 4);
verifyWarning(testCase, @get_and_plot, 'NIMS:HardnessPlot:IncompatibleAxis');
gui = guidata(fig);
verifyEqual(testCase, get(gui.handles.value_param2plotinxaxis_GUI, 'Value'), 1);
verifyEqual(testCase, get(gui.handles.cb_SD_plot_GUI, 'Enable'), 'on');
verifyEqual(testCase, get(gui.handles.cb_lines_plot_GUI, 'Enable'), 'on');
end
