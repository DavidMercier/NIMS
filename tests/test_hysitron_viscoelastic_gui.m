function tests = test_hysitron_viscoelastic_gui
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
demo;
fig = gcf;
testCase.TestData.fig = fig;
gui = guidata(fig);
file = fullfile(gui.config.NIMSroot, 'data_indentation', 'Hysitron_dma.txt');
imported = importdata(file);
data = imported.data;
[storage, loss] = hysitron_viscoelastic_stiffness(file, data);
verifyEqual(testCase, storage, data(:,20) .* 1000);
verifyEqual(testCase, loss, data(:,21) .* 1000);
gui.data.h_init = data(:,2);
gui.data.delta_h_init = zeros(size(data,1),1);
gui.data.P_init = data(:,4);
gui.data.delta_P_init = zeros(size(data,1),1);
gui.data.S_init = 1 ./ data(:,12);
gui.data.delta_S_init = zeros(size(data,1),1);
gui.data.storage_stiffness_init = storage;
gui.data.loss_stiffness_init = loss;
gui.data = extract_loading_segment(gui.data);
gui.flag.flag_data = 1;
gui.flag.flag_no_csm = 0;
guidata(fig, gui);
set_unit(fig, {'nm', 'uN', 'N/m'});
set(gui.handles.value_mindepth_GUI, 'String', num2str(round(min(gui.data.h_init))));
set(gui.handles.value_maxdepth_GUI, 'String', num2str(round(max(gui.data.h_init))));
figure(fig);
end

function teardownOnce(testCase)
if isgraphics(testCase.TestData.fig)
    delete(testCase.TestData.fig);
end
end

function testViscoelasticYAxisChoices(testCase)
fig = testCase.TestData.fig;
figure(fig);
gui = guidata(fig);
for selection = 10:12
    set(gui.handles.value_param2plotinyaxis_GUI, 'Value', selection);
    get_and_plot;
    gui = guidata(fig);
    if selection == 10
        values = gui.results.storage_modulus;
    elseif selection == 11
        values = gui.results.loss_modulus;
    else
        values = gui.results.loss_tangent;
    end
    verifyEqual(testCase, gui.axis.y2plot, values);
    verifyTrue(testCase, any(isfinite(values)));
    valid = isfinite(gui.results.loss_tangent);
    selected = find(gui.data.h_init > gui.data.min_depth & ...
        gui.data.h_init < gui.data.max_depth);
    storage = reshape(gui.data.storage_stiffness_init(selected), 1, []);
    loss = reshape(gui.data.loss_stiffness_init(selected), 1, []);
    verifyEqual(testCase, gui.results.loss_tangent(valid), ...
        loss(valid) ./ storage(valid), 'AbsTol', 1e-12);
    expectedStorage = 1e-9 .* storage(valid) .* ...
        sqrt(pi ./ (gui.results.Ac(valid) .* 1e-18)) ./ ...
        (2 .* gui.config.numerics.beta_Val);
    verifyEqual(testCase, gui.results.storage_modulus(valid), ...
        expectedStorage, 'RelTol', 1e-12);
    verifyEqual(testCase, gui.results.loss_tangent(valid), ...
        gui.results.loss_modulus(valid) ./ gui.results.storage_modulus(valid), ...
        'AbsTol', 1e-12);
end
verifyEqual(testCase, char(get(gui.handles.value_model_GUI, 'Visible')), 'off');
end
