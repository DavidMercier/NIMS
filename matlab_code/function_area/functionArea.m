%% Copyright 2014 MERCIER David
function Ac = functionArea(hc, coeffArea, varargin)
%% Function used to calculate the contact area during an indentation test
% from Oliver et al. (1992) - http://dx.doi.org/10.1557/JMR.1992.1564

% Ac: Indentation contact area in nm2
% hc: Indentation contact depth in nm
% coeffArea: Area coefficients

if nargin < 2
    hc = 1;
    pyrAngle = 65.3; % Face angle of the Berkovich indenter in degrees
    C1 = projectedArea_3sidePyramid(hc, pyrAngle);
    coeffArea = [C1 0 0 0 0 0 0 0 0]; % Coefficients of the function area
end

if nargin < 1
    hc = 100; % Contact indentation depth in nm
end

Ac = coeffArea(1).*hc.^2 + ...
    coeffArea(2).*hc.^1 + ...
    coeffArea(3).*hc.^(1/2) + ...
    coeffArea(4).*hc.^(1/4) + ...
    coeffArea(5).*hc.^(1/8) + ...
    coeffArea(6).*hc.^(1/16) + ...
    coeffArea(7).*hc.^(1/32) + ...
    coeffArea(8).*hc.^(1/64) + ...
    coeffArea(9).*hc.^(1/128);

end