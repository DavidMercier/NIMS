%% Copyright 2014 MERCIER David
function edit_YAML_config_file
%% Function used to edit YAML configuration file
[YAML_filename, YAML_pathname] = ...
    uigetfile(['YAML_config_files\', '*.yaml'], 'File Selector');

edit([YAML_pathname, YAML_filename]);

end