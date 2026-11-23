function [storage, loss] = hysitron_viscoelastic_stiffness(filename, data)
% Read Hysitron nanoDMA stiffness columns in uN/nm and return N/m.
storage = [];
loss = [];
file = fopen(filename, 'r', 'n', 'ISO-8859-1');
if file < 0
    error('NIMS:Viscoelastic:FileOpen', 'Cannot open Hysitron DMA file.');
end
cleanup = onCleanup(@() fclose(file));
header = '';
while ischar(header)
    if ~isempty(strfind(header, 'Storage Stiff.')) || ...
            ~isempty(strfind(header, 'Loss Stiff.'))
        break;
    end
    header = fgetl(file);
end
if ~ischar(header)
    return;
end
columns = strsplit(header, sprintf('\t'), 'CollapseDelimiters', false);
storageColumn = find(~cellfun('isempty', strfind(columns, 'Storage Stiff.')));
lossColumn = find(~cellfun('isempty', strfind(columns, 'Loss Stiff.')));
if numel(storageColumn) ~= 1 || numel(lossColumn) ~= 1 || ...
        max([storageColumn, lossColumn]) > size(data, 2)
    error('NIMS:Viscoelastic:InvalidColumns', ...
        'The Hysitron file must contain one storage and one loss stiffness column.');
end
for index = [storageColumn, lossColumn]
    units = regexp(columns{index}, '\(([^)]*)\)', 'tokens', 'once');
    if isempty(units) || numel(units{1}) < 5 || ...
            ~strcmp(units{1}(end-3:end), 'N/nm')
        error('NIMS:Viscoelastic:InvalidUnits', ...
            'Hysitron storage and loss stiffness must be in uN/nm.');
    end
    prefix = double(units{1}(1:end-4));
    if ~(isequal(prefix, 117) || isequal(prefix, 181) || ...
            isequal(prefix, [194 181]) || isequal(prefix, [206 188]))
        error('NIMS:Viscoelastic:InvalidUnits', ...
            'Hysitron storage and loss stiffness must be in uN/nm.');
    end
end
storage = data(:, storageColumn) .* 1000;
loss = data(:, lossColumn) .* 1000;
end
