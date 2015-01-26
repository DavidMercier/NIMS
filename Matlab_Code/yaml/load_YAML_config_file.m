%% Copyright 2014 MERCIER David
function [indenter, data, numerics, flag_YAML] = load_YAML_config_file
%% Function used to load YAML configuration file

flag_YAML = 1;

configYAML = sprintf('indenters_config.yaml');
if ~exist(configYAML, 'file')
    errordlg('indenters_config.yaml doesn''t exist !', 'File Error');
    flag_YAML = 0;
else
    indenter = ReadYaml(configYAML);
    
    if ~isfield(indenter, 'Indenter_IDs')
        indenter.Indenter_IDs = {'No Indenter defined'};
    end
    
    if ~isfield(indenter, 'Indenter_ID')
        indenter.Indenter_ID = 'No Indenter defined';
    end
    
    if ~isfield(indenter, 'Indenter_materials')
        indenter.Indenter_materials = {'No Indenter defined'};
    end
    if ~isfield(indenter, 'Indenter_material')
        indenter.Indenter_material = 'No Indenter defined';
    end
end

configYAML = sprintf('data_config.yaml');
if ~exist(configYAML, 'file')
    errordlg('data_config.yaml doesn''t exist !', 'File Error');
    flag_YAML = 0;
else
    data = ReadYaml(configYAML);
    if ~isfield(data, 'data_path')
        data.data_path = '';
    end
end

configYAML = sprintf('numerics_config.yaml');
if ~exist(configYAML, 'file')
    errordlg('numerics_config.yaml doesn''t exist !', 'File Error');
    flag_YAML = 0;
else
    numerics = ReadYaml(configYAML);
end

if flag_YAML
   display('YAML configuration files correctly loaded...');
end

end