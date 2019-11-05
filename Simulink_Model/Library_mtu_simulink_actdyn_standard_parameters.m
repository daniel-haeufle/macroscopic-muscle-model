% standard parameters for Hatze activation dynamics
%

function PA = Library_mtu_simulink_actdyn_standard_parameters

PA.m         = 11.3;    %[1/s] Time constant for activation dynamics. Hatze gibt Werte zwischen 3.67 (langsame Fasern) und 11.25 (schnelle Fasern)an; bei Kistemaker m = 11.3
PA.c         = 1.37e-4; % [mol/l] Kistemaker et al., 2006, S. 2908, siehe Tabelle
PA.eta       = 5.27e4;  % [l/mol] Kistemaker et al., 2006, S. 2908, siehe Tabelle
PA.k         = 2.9;     % [] Kistemaker et al., 2006, S. 2908, siehe Tabelle
PA.q_0       = 0.005;   % [] Guenther (1997) bzw. Kistemaker et al. (2006)
PA.nu        = 3;       % [] 3 bei Kistemaker et al., 2006, Rockenfeller et al. 2015; 2 bei Guenther, 1997;

end
