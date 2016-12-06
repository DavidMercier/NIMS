%% Copyright 2014 MERCIER David
function hr = plasticDepth(h, P, S, varargin)
%% Function used to calculate the (residual) plastic depth from
% Guillonneau G. et al. (2014) - http://dx.doi.org/10.1016/j.triboint.2013.10.013

% hr: Residual or plastic depth in nm

if nargin < 3
    S = 0.08; % Contact stiffness in mN/nm
end

if nargin < 3
    P = 0.2; % Load in mN
end

if nargin < 1
    h = 100; % Total indentation depth in nm
end

hr = h - (P./S);

end