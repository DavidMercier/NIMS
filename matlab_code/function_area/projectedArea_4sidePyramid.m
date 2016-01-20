%% Copyright 2014 MERCIER David
function Ap = projectedArea_4sidePyramid(hc, pyrAngle, varargin)
%% Function used to calculate the projected contact area of a 4-sided pyramidal indenter

% Ap: Projected contact area in nm2
% hc: Indentation contact depth in nm
% pyrAngle: Face angle of the pyramid in degrees

if nargin < 1
    figure('Name', 'Projected contact area of a Vickers indenter',...
        'NumberTitle', 'off');
    
    hc = (0:1:100)';
    pyrAngle = 68; % Face angle of the Vickers indenter in degrees
    Ap = projectedArea_4sidePyramid(hc, pyrAngle);
    
    plot(hc, Ap, 'b-', 'LineWidth', 2, 'MarkerSize', 10);
    
    xlabel('h_c (in nm)', 'Color', [0,0,0], 'FontSize', 14);
    ylabel('A_p  (in nm^2)', 'Color', [0,0,0], 'FontSize', 14);
    set(gca, 'FontSize', 14);
    grid on;
    
    %save_figure(pwd, gca, '_projectedArea_Vickers');
end

Ap = (4.*hc.^2) .* (tand(pyrAngle).^2);

end