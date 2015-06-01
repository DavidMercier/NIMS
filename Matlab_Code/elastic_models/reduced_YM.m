%% Copyright 2014 MERCIER David
function Esample_red = reduced_YM(Esample, nu, varargin)
%% Function used to calculate the reduced Young's modulus value
% Esample : Young's modulus in GPa
% nu : Poisson's coefficient
% Esample_red: Reduced Young's modulus in GPa

if nargin == 0
    Esample = 180; % in GPa
    nu = 0.3;
    display(Esample);
    display(nu);
end

Esample_red = Esample / (1-nu^2);

end