function unloading = mts_unloading_segment(raw)
% Select the first unloading segment, including the preceding peak sample.
unloading = struct('h', [], 'P', [], 'delta_P', []);
labels = raw(:,1);
first = find(strcmp(labels, 'Unload From Peak Segment Type'), 1);
if isempty(first)
    return;
end
next_loading = find(strcmp(labels(4:end), 'Load Segment Type'), 1);
if ~isempty(next_loading) && next_loading + 3 < first
    return;
end

next = find(cellfun(@(value) ischar(value) && ...
    (~isempty(strfind(value, 'Segment')) || strcmp(value, 'END')), ...
    labels(first+1:end)), 1);
if isempty(next)
    last = size(raw, 1);
else
    last = first + next - 1;
end
first = max(3, first - 1);
names = {'Displacement Into Surface', 'Load On Sample', ...
    'STANDARD DEVIATION (Load On Sample)'};
columns = zeros(1, 3);
for ii = 1:3
    index = find(strcmp(raw(1,:), names{ii}));
    if numel(index) > 1 || (ii < 3 && isempty(index))
        error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
            'Unloading data require unique displacement and load columns.');
    end
    if ~isempty(index)
        columns(ii) = index;
    end
end
values = raw(first:last, columns(1:2));
if ~all(cellfun(@(value) isnumeric(value) && isscalar(value) && ...
        isfinite(value), values(:)))
    error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
        'Unloading displacement and load must be finite numbers.');
end
values = cell2mat(values);
unloading.h = values(:,1);
unloading.P = values(:,2);
unloading.delta_P = zeros(size(unloading.P));
if columns(3) ~= 0
    deviations = raw(first:last, columns(3));
    if ~all(cellfun(@(value) isnumeric(value) && isscalar(value) && ...
            isfinite(value), deviations(:)))
        error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
            'Unloading load uncertainties must be finite numbers.');
    end
    unloading.delta_P = cell2mat(deviations);
end
end
