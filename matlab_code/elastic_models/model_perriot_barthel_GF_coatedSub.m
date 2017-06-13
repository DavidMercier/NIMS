%% Copyright 2014 MERCIER David
function model_perriot_barthel_GF_coatedSub
%% Function used to calculate Young's modulus in bilayer system with
% the model of Perriot et al. (2003)

Ef = 0.1:0.1:1000;
Es = 10;
E_ratio = Es./Ef; % E_ratio = Es./Ef

log_k = -0.093 + 0.792.*log10(E_ratio) + 0.05.*(log10(E_ratio)).^2;

n = 1.27;

t_over_a = 1;

psi_PB = (1+(t_over_a*(10.^log_k)).^n);
Eff = Ef + (Es-Ef)./psi_PB;
errorE = (Eff - Ef)./Ef;


plot(E_ratio, t_over_a_crit);
set(gca,'XScale','log') 
grid on;

end