%% Copyright 2014 MERCIER David
function Ap = projectedArea_TiltAngle(hc, pyrAngle, tiltAngle, rotationAngle, varargin)
%% Function used to calculate the projected contact area of a triangular
% pyramidal indentation into a tilted surface
% from Kashani and Madhavan (2010) - http://dx.doi.org/10.1016/j.actamat.2010.09.051

% Ap: Projected contact area in nm2
% hc: Indentation contact depth in nm
% pyrAngle: Face angle of the pyramid in degrees
% tiltAngle: Angle of the tilted sample from the horizontal plane in degrees
% rotationAngle: Rotation angle of the pyramidal indenter in degrees

if nargin < 4
    figure('Name', 'Projected contact area of a triangular pyramidal indentation into a tilted surface',...
        'NumberTitle', 'off');
    
    hc = 1;
    pyrAngle = 65.3; % Berkovich indenter
    rotationAngle = (0:5:120)';
    maxTilt = 5;
    
    % Setting of color/width of lines
    c1 = 0;
    c2 = 0;
    c3 = 0;
    lw = 1;
    
    for tiltAngle = 1:1:maxTilt
        Ap = projectedArea_TiltAngle(hc, pyrAngle, tiltAngle, rotationAngle);
        Ap0 = projectedArea_3sidePyramid(hc, pyrAngle);
        
        plot(rotationAngle, Ap/Ap0, ...
            'Color',[c1 c2 c3],...
            'Linewidth', lw);
        
        xlabel('Rotation angle (in °)', 'Color', [0,0,0], 'FontSize', 14);
        ylabel('A_p/A_{p0}', 'Color', [0,0,0], 'FontSize', 14);
        set(gca, 'FontSize', 14);
        
        legendInfo{tiltAngle} = (strcat('Tilt angle=', num2str(tiltAngle), '°'));
        c1 = c1 + 1/maxTilt;
        c2 = c2 + 1/maxTilt;
        c3 = c3 + 1/maxTilt;
        lw = lw + 1;
        hold on;
        
    end
    
    grid on;
    legend(legendInfo);
    %save_figure(pwd, gca, '_projectedArea_TiltAngle');
end

Ap = (3.*(3.^0.5) .* (hc.^2) .* (tand(pyrAngle).^2)) ./ ...
    (1 - (3.*(tand(pyrAngle).^2) .* (tand(tiltAngle).^2)) - ...
    (2.*(tand(pyrAngle).^3) .* (tand(tiltAngle).^3) .* cosd(3.*rotationAngle)));

end