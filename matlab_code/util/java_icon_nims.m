%% Copyright 2014 MERCIER David
function java_icon_nims(gui_handle, logo, varargin)
%% To change icon of the GUI
% gui_handle: Handle of the GUI
% logo: Picture used as a logo for the GUI

% author: d.mercier@mpie.de

if nargin < 2
    logo = fullfile('doc', '_pictures', 'icon_nims.png');
end

if nargin < 1
    gui_handle = gcf;
end

try
    jframe = get(gui_handle, 'JavaFrame');
catch exception
    if ~isempty(strfind(exception.message, ...
            'The JavaFrame property has been removed'))
        return;
    end
    rethrow(exception);
end

wrn = warning;
wrn_txt = wrn.identifier;
warning('off', wrn_txt);
jIcon = javax.swing.ImageIcon(logo);
jframe.setFigureIcon(jIcon);
warning(wrn);

end