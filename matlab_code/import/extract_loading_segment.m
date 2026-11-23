function [data, discarded, unloading] = extract_loading_segment(data)
% Select the samples through the first maximum load.
fields = {'h_init', 'delta_h_init', 'P_init', 'delta_P_init', ...
    'S_init', 'delta_S_init'};
optional = {'storage_stiffness_init', 'loss_stiffness_init'};
for ii = 1:numel(optional)
    if isfield(data, optional{ii})
        fields{end+1} = optional{ii};
    end
end
load_values = data.P_init;
if ~isvector(load_values) || numel(load_values) < 2 || ...
        any(~isfinite(load_values(:)))
    error('NIMS:LoadingSegment:InvalidLoad', ...
        'At least two finite load measurements are required.');
end
for ii = 1:numel(fields)
    if ~isvector(data.(fields{ii})) || ...
            numel(data.(fields{ii})) ~= numel(load_values)
        error('NIMS:LoadingSegment:InvalidData', ...
            'Load, displacement, stiffness and uncertainties must be aligned.');
    end
end

[~, peak] = max(load_values);
if peak == 1
    error('NIMS:LoadingSegment:NoLoading', ...
        'The maximum load is the first sample; no loading segment was found.');
end
discarded = numel(load_values) - peak;
unloading = struct('h', [], 'P', [], 'delta_P', []);
if any(load_values(peak+1:end) < load_values(peak))
    unloading.h = data.h_init(peak:end);
    unloading.P = data.P_init(peak:end);
    unloading.delta_P = data.delta_P_init(peak:end);
end
for ii = 1:numel(fields)
    values = data.(fields{ii});
    data.(fields{ii}) = values(1:peak);
end
end
