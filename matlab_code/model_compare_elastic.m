function model_compare_elastic(selected)
% Fit each model from the same measurements and input properties.
fig = gcf;
baseline = guidata(fig);
substrate = get(baseline.handles.value_youngsub_GUI, 'String');
thickness_correction = get(baseline.handles.cb_corr_thickness_GUI, 'Value');
cleanup = onCleanup(@() restore_inputs(baseline, substrate, thickness_correction));
models = cell(1, numel(selected));

for ii = 1:numel(selected)
    restore_inputs(baseline, substrate, thickness_correction);
    guidata(fig, baseline);
    model_bilayer_elastic(selected(ii));
    fitted = guidata(fig);
    exitflag = NaN;
    if isfield(fitted.results, 'exitflag')
        exitflag = fitted.results.exitflag;
    end
    models{ii} = struct('name', baseline.handles.list_bilayermodel{selected(ii)}, ...
        'Em_red', fitted.results.Em_red, 'Ef_red', fitted.results.Ef_red, ...
        'Ef_sol_fit', fitted.results.Ef_sol_fit, 'exitflag', exitflag, ...
        'thickness_corrected', thickness_correction == 1 && selected(ii) ~= 11);
    if ii == 1
        primary = fitted;
    end
end

primary.results.elastic_comparison = models;
guidata(fig, primary);
restore_inputs(baseline, substrate, thickness_correction);
end

function restore_inputs(baseline, substrate, thickness_correction)
set(baseline.handles.value_youngsub_GUI, 'String', substrate);
set(baseline.handles.cb_corr_thickness_GUI, 'Value', thickness_correction);
end
