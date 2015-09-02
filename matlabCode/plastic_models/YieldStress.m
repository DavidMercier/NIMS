%% Copyright 2014 MERCIER David
function yieldStressValue = YieldStress(Hsample, C, varargin)
%% Function used to calculate the yield stress from Tabor's relationship.

% See Tabor D., "The hardness of metals" (1951).

% See Johnson K.L., "The correlation of indentation experiments" (1970) /
% DOI : 10.1016/0022-5096(70)90029-3

if nargin < 2
    C = 2.8;
end

if nargin < 1
    Hsample = 1; % in GPa
end

yieldStressValue = Hsample / C;

end