%% Copyright 2014 MERCIER David
function customized_menu(parent)
%% Setting of customized menu
% parent: handle of the GUI

help_menu = uimenu(parent, 'Label', 'Help_Toolbox');

uimenu(help_menu, 'Label', 'HTML Documentation', ...
    'Callback', 'gui = guidata(gcf); web(gui.config.url_help,''-browser'')');
end