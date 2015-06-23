%% Copyright 2014 MERCIER David
function nims_root = get_nims_root
%% Get environment variable for NIMS

nims_root = getenv('NIMS_TBX_ROOT');

if isempty(nims_root)
    msg = 'Run the path_management.m script !';
    commandwindow;
    display(msg);
    %errordlg(msg, 'File Error');
    error(msg);
end

end