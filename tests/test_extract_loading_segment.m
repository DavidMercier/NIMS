function tests = test_extract_loading_segment
tests = functiontests(localfunctions);
end

function testLoadingAndUnloadingStayAligned(testCase)
data = fixture([1; 3; 5; 5; 4; 1]);
data.storage_stiffness_init = (51:56)';
data.loss_stiffness_init = (61:66)';
[result, discarded, unloading] = extract_loading_segment(data);
verifyEqual(testCase, discarded, 3);
verifyEqual(testCase, unloading.h, data.h_init(3:6));
verifyEqual(testCase, unloading.P, data.P_init(3:6));
verifyEqual(testCase, unloading.delta_P, data.delta_P_init(3:6));
names = fieldnames(data);
for ii = 1:numel(names)
    original = data.(names{ii});
    verifyEqual(testCase, result.(names{ii}), original(1:3));
end
end

function testLoadingOnlyAndSmallFluctuations(testCase)
data = fixture([1; 3; 2.9; 5]);
[result, discarded, unloading] = extract_loading_segment(data);
verifyEqual(testCase, result, data);
verifyEqual(testCase, discarded, 0);
verifyEmpty(testCase, unloading.P);
data = fixture([1; 3; 3]);
[~, ~, unloading] = extract_loading_segment(data);
verifyEmpty(testCase, unloading.P);
end

function testInvalidOrUnloadingOnlyData(testCase)
data = fixture([2; 1]);
verifyError(testCase, @() extract_loading_segment(data), ...
    'NIMS:LoadingSegment:NoLoading');
data = fixture([1; NaN; 2]);
verifyError(testCase, @() extract_loading_segment(data), ...
    'NIMS:LoadingSegment:InvalidLoad');
data = fixture([1; 2; 3]);
data.S_init = [1; 2];
verifyError(testCase, @() extract_loading_segment(data), ...
    'NIMS:LoadingSegment:InvalidData');
end

function testSpreadsheetRowsAndColumns(testCase)
raw = {NaN, 'Load On Sample', 'STANDARD DEVIATION (Load On Sample)', ...
    'Harmonic Contact Stiffness', 'STANDARD DEVIATION (Harmonic Contact Stiffness)', ...
    'Displacement Into Surface', 'STANDARD DEVIATION (Displacement Into Surface)'; ...
    NaN, 'mN', 'mN', 'N/m', 'N/m', 'nm', 'nm'; ...
    'Load Segment Type', 1, 0.1, 10, 0.2, 100, 0.3; ...
    NaN, 2, 0.4, 20, 0.5, 200, 0.6; ...
    'Hold Segment Type', 3, 0.7, 30, 0.8, 300, 0.9};
[data, unit] = mts_segment_data(raw, 4);
verifyEqual(testCase, data, [100, 0.3, 1, 0.1, 10, 0.2; ...
    200, 0.6, 2, 0.4, 20, 0.5]);
verifyEqual(testCase, unit, {'nm', 'mN', 'N/m'});
raw(:, [3, 5, 7]) = [];
[data, unit] = mts_segment_data(raw, 4);
verifyEqual(testCase, data, [100, 1, 10; 200, 2, 20]);
verifyEqual(testCase, unit, {'nm', 'mN', 'N/m'});
end

function testMarkedUnloadingStopsAtNextSegment(testCase)
raw = {NaN, 'Displacement Into Surface', 'Load On Sample', ...
    'STANDARD DEVIATION (Load On Sample)'; ...
    NaN, 'nm', 'mN', 'mN'; ...
    'Load Segment Type', 10, 1, 0.1; ...
    'Hold Segment Type', 30, 5, 0.2; ...
    NaN, 31, 5, 0.3; ...
    'Unload From Peak Segment Type', 25, 3, 0.4; ...
    NaN, 20, 1, 0.5; ...
    'Thermal Drift Hold Segment', 19, 0.9, 0.6; ...
    'END', NaN, NaN, NaN};
unloading = mts_unloading_segment(raw);
verifyEqual(testCase, unloading.h, [31; 25; 20]);
verifyEqual(testCase, unloading.P, [5; 3; 1]);
verifyEqual(testCase, unloading.delta_P, [0.3; 0.4; 0.5]);
raw{6,1} = 'Load Segment Type';
verifyEmpty(testCase, mts_unloading_segment(raw).P);
end

function data = fixture(load_values)
n = numel(load_values);
data.h_init = (1:n)';
data.delta_h_init = (11:10+n)';
data.P_init = load_values;
data.delta_P_init = (21:20+n)';
data.S_init = (31:30+n)';
data.delta_S_init = (41:40+n)';
end
