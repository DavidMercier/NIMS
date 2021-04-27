%% Copyright 2014 MERCIER David
function set_default_values_txtbox (ui_txtbox, def_str)
%% Function used to set default values in case of missing parameters
% uitxtbox : name of the handle of the edit text box
% def_str : default string for the corresponding variable

if nargin < 2
    def_str = '1';
end

try
    if isempty(get(ui_txtbox, 'String')) == 1
        set(ui_txtbox, 'String', def_str);
    end
catch err
    warning(err.message);
    warning('Don''t forget to press "Enter" once you changed a numerical value in your inputs');
end

end