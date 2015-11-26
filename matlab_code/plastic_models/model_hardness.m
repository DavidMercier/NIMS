%% Copyright 2014 MERCIER David
function hardness = model_hardness(max_load, contact_area, varargin)
%% Function used to calculate the hardness of the sample. See in Oliver et al. (1992).
% max_load = Maximum of load (in mN)
% contact area = Contact area (in nm2)
% hardness = Hardness (in GPa)

if nargin == 0
    max_load = randi(30) / 10;
    contact_area = randi(200) * 1e4;
    display(max_load);
    display(contact_area);
end

hardness = 1e6 * (max_load./contact_area);

end