%% Copyright 2014 MERCIER David
function L_Jung = sigmoidal_jung(x, A_Jung, B_Jung)
%% Sigmoidal function used by Jung et al. (2004)
% to satisfy the boundary conditions of his model.

% A_Jung and B_Jung are adjustable coefficients

L_Jung = (1./(1+A_Jung.*x.^B_Jung));


end