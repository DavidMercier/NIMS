function [data, unit] = mts_segment_data(raw, last_row)
% Read the selected spreadsheet rows without relying on xlsread ranges.
names = {'Displacement Into Surface', 'Load On Sample', ...
    'Harmonic Contact Stiffness'};
deviations = {'STANDARD DEVIATION (Displacement Into Surface)', ...
    'STANDARD DEVIATION (Load On Sample)', ...
    'STANDARD DEVIATION (Harmonic Contact Stiffness)'};
columns = zeros(1, 3);
sd_columns = zeros(1, 3);
for ii = 1:3
    index = find(strcmp(raw(1,:), names{ii}));
    sd_index = find(strcmp(raw(1,:), deviations{ii}));
    if numel(index) ~= 1 || numel(sd_index) > 1
        error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
            'The spreadsheet must have one column for each measurement.');
    end
    columns(ii) = index;
    if ~isempty(sd_index)
        sd_columns(ii) = sd_index;
    end
end
if all(sd_columns == 0)
    selected = columns;
elseif all(sd_columns ~= 0)
    selected = reshape([columns; sd_columns], 1, []);
else
    error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
        'Standard-deviation columns must be present for all measurements or none.');
end
if last_row < 4 || last_row > size(raw, 1)
    error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
        'The spreadsheet must contain at least two loading samples.');
end
values = raw(3:last_row, selected);
if ~all(cellfun(@(value) isnumeric(value) && isscalar(value) && ...
        isfinite(value), values(:)))
    error('NIMS:LoadingSegment:InvalidSpreadsheet', ...
        'Loading measurements and standard deviations must be finite numbers.');
end
data = cell2mat(values);
unit = raw(2, columns);
end
