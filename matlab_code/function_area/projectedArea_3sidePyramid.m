%% Copyright 2014 MERCIER David
function Ap = projectedArea_3sidePyramid(hc, pyrAngle, varargin)
%% Function used to calculate the projected contact area of a 3-sided pyramidal indenter

% Ap: Projected contact area in nm2
% hc: Indentation contact depth in nm
% pyrAngle: Face angle of the pyramid in degrees

if nargin < 1
    figure('Name', 'Projected contact area of a Berkovich indenter',...
        'NumberTitle', 'off');
    
    hc = (0:1:100)';
    pyrAngle = 65.3; % Face angle of the Berkovich indenter in degrees
    Ap = projectedArea_3sidePyramid(hc, pyrAngle);
    
    plot(hc, Ap, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    
    xlabel('h_c (in nm)', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('A_p  (in nm^2)', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    
    %save_figure(pwd, gca, '_projectedArea_Berkovich');
end

Ap = 3.*(3.^0.5) .* (hc.^2) .* (tand(pyrAngle).^2);

end