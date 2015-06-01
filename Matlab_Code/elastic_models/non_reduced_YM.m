%% Copyright 2014 MERCIER David
function Esample = non_reduced_YM(Esample_red, nu, varargin)
%% Function used to calculate the non reduced Young's modulus value
% Esample_red: Reduced Young's modulus in GPa
% nu : Poisson's coefficient
% Esample : Young's modulus in GPa

if nargin == 0
    Esample_red = 180; % in GPa
    nu = 0.3;
    display(Esample_red);
    display(nu);
end

Esample = Esample_red * (1-nu^2);

end