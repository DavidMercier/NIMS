%% Copyright 2014 MERCIER David
function YM_voigtAverage = elasticModulus_VoigtAverage(...
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

YM_voigtAverage = sum(volumeFraction .* elasticModulus);

end