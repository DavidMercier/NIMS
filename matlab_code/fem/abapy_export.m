function abapy_export(pythonExecutable, outputFile, young, poisson, depth, meshSize, angle, films, substrateDepth, width, prepareScript)
% Export an axisymmetric input, or prepare its script without Abapy.
% Lengths are nm, Young's modulus is GPa, and angle is degrees.
% Optional films rows are [thickness Young Poisson], surface to substrate.
if nargin < 7
    angle = 70.3;
end
if nargin < 6
    error('NIMS:Abapy:Arguments', ['Provide pythonExecutable, outputFile, ', ...
        'young, poisson, depth, and meshSize.']);
end
values = [young, poisson, depth, meshSize, angle];
if numel(values) ~= 5 || ~isreal(values) || any(~isfinite(values))
    error('NIMS:Abapy:Arguments', 'Model parameters must be finite real scalars.');
end
if nargin < 11
    prepareScript = false;
end
if nargin < 8
    films = [];
end
extra = '';
if ~isempty(films)
    if nargin < 10
        error('NIMS:Abapy:Arguments', 'Multilayer export requires substrateDepth and width.');
    end
    validateattributes(films, {'numeric'}, {'real', 'finite', '2d', 'ncols', 3});
    validateattributes(substrateDepth, {'numeric'}, {'real', 'finite', 'scalar', 'positive'});
    validateattributes(width, {'numeric'}, {'real', 'finite', 'scalar', 'positive'});
    for ii = 1:size(films, 1)
        extra = [extra sprintf(' --film %.17g %.17g %.17g', films(ii, :))];
    end
    extra = [extra sprintf(' --substrate-depth %.17g --width %.17g', substrateDepth, width)];
end
validateattributes(prepareScript, {'logical'}, {'scalar'});
if prepareScript
    extra = [extra ' --prepare-script'];
end
script = fullfile(fileparts(mfilename('fullpath')), 'abapy_export.py');
command = sprintf('%s %s --output %s --young %.17g --poisson %.17g --depth %.17g --mesh-size %.17g --angle %.17g%s 2>&1', ...
    shellquote(pythonExecutable), shellquote(script), shellquote(outputFile), ...
    young, poisson, depth, meshSize, angle, extra);
[status, output] = system(command);
if status ~= 0
    error('NIMS:Abapy:ExportFailed', 'Abapy export failed (status %d):\n%s', status, output);
end
fprintf('%s', output);
end

function quoted = shellquote(value)
if ~ischar(value) || isempty(value)
    error('NIMS:Abapy:Path', 'Paths must be nonempty character vectors.');
end
if ispc
    if any(ismember(value, ['"%' char(33) char(10) char(13)]))
        error('NIMS:Abapy:Path', 'Path contains characters unsupported by the Windows command shell.');
    end
    quoted = ['"' value '"'];
else
    quoted = ['''' strrep(value, '''', '''"''"''') ''''];
end
end
