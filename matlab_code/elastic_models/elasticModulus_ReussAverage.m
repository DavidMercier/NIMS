%% Copyright 2014 MERCIER David
function YM_reussAverage = elasticModulus_ReussAverage(...
    elasticModulus, volumeFraction, varargin)
%% Function giving the Voigt's average of elastic modulus
% From "Mechanical Behavior of Materials", by Meyers M and Chawla K.,
% 2nd edition, 2008.

% author: david.mercier@crmgroup.be

if nargin < 2
    volumeFraction = [20 80]/100; % in %
end

if nargin < 1
    elasticModulus = [200 350]; % in GPa
end

YM_reussAverage = sum(volumeFraction .* elasticModulus);

end