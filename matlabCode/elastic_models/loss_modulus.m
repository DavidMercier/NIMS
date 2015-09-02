%% Copyright 2014 MERCIER David
function lossModulus = ...
    loss_modulus(harmonicDamping, freqOscil, contact_area, varargin)
%% Function used for the calculation of the loss modulus from dynamic nanoindentation
% harmonicDamping : Harmonic contact damping in (N.s)/nm
% freqOscil : Frequency of the small dynamic oscillation in Hz
% contact_area : Contact area in nm2
% loss_modulus: The loss modulus in GPa

if nargin == 0
    contact_area = 5e7;
    freqOscil = 45;
    harmonicDamping = 0.001;
end

lossModulus = 10^6 .* (harmonicDamping * freqOscil)/2 .* ...
    (pi./contact_area).^0.5;

end