%% Copyright 2014 MERCIER David
function save_figure(path_data, figure, title_YAMLfile, varargin)
%% Function to save a figure from a GUI
% path_data : path used to store the copy of the figure saved
% figure : figure to save
% title_YAMLfile : title of the figure to save

if nargin < 3
    title_YAMLfile = 'Current_figure';
end

if nargin < 2
    figure = axes;
end

if nargin < 1
    path_data = pwd;
end

%% Isolation of the figure from the GUI
isolated_figure = isolate_axes(figure);

%% Defintion of the title of the figure
%date_str = strcat(datestr(now,'yyyy-mmm-dd_HH'),'H',datestr(now,'MM'),'min',datestr(now,'ss'),'s');
isolated_figure_title = strcat(path_data, title_YAMLfile);

%% Exportation of the figure in a .png format
export_fig(sprintf('%s', char(isolated_figure_title)), '-png')

end