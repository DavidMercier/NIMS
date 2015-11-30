%% Copyright 2014 MERCIER David
function tridim_mapping(x_step, y_step, expValues, expProp, varargin)
%% Function to plot a 3D map of elastic/plastic properties in function of X/Y coordinates
% expValues : Elastic (Young's modulus) or plastic (hardness) properties
% obtained experimentally by indentation in GPa.
% x_step and y_step : Steps between indents in X and Y axis in microns.

if nargin < 4
    expProp = 1;
end

if nargin < 3
    %expValues = randi(100,100);
    expValues = peaks(100);
end

if nargin < 2
    y_step = 30; % in microns
end

if nargin < 1
    x_step = 20; % in microsn
end

xData = zeros(size(expValues,1));
xData(1) = 0;
for ii = 2:size(expValues,1)
    for jj = 1:size(expValues,2)
        xData(ii,jj) = xData(ii-1,1) + x_step;
    end
end

yData = zeros(size(expValues,2));
yData(1) = 0;
for ii = 2:size(expValues,2)
    for jj = 1:size(expValues,1)
        yData(ii,jj) = yData(ii-1,1) + y_step;
    end
end

% Plots
figure;
colormap hsv;

% Axes properties
if expProp == 1
    zString = 'Young''s modulus';
elseif expProp == 2
    zString = 'Hardness';
end

% Subplot 1
subplot(2,1,1);
surf(xData', yData, expValues,...
    'FaceColor','interp',...
    'EdgeColor','none',...
    'FaceLighting','gouraud')

axis tight;
view(-50,30);
camlight left;

hXLabel_1 = xlabel('X coordinates ($\mu$m)');
hYLabel_1 = ylabel('Y coordinates ($\mu$m)');
hZLabel_1 = zlabel([zString, '(GPa)']);
hTitle_1 = title(['3D map of ', zString], 'FontSize', 18);

set([hXLabel_1, hYLabel_1, hZLabel_1, hTitle_1], 'Color', [0,0,0], 'FontSize', 14, ...
    'Interpreter', 'Latex');

% Subplot 2
subplot(2,1,2);
surf(xData', yData, expValues,...
    'FaceColor','interp',...
    'EdgeColor','none',...
    'FaceLighting','gouraud')

%axis tight;
view(0,90);

hXLabel_2 = xlabel('X coordinates ($\mu$m)');
hYLabel_2 = ylabel('Y coordinates ($\mu$m)');
hZLabel_2 = zlabel([zString, '(GPa)']);
hTitle_2 = title(['3D map of ', zString], 'FontSize', 18);

set([hXLabel_2, hYLabel_2, hZLabel_2, hTitle_2], ...
    'Color', [0,0,0], 'FontSize', 14, 'Interpreter', 'Latex');

end