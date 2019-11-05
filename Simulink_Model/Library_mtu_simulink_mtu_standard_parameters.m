% This function inizializes the muscle tendon complex parameters to the
% matlab workspace.



function MP = Library_mtu_simulink_mtu_standard_parameters(MP)

% contractile element (CE)
%===========================
MP.CE.DeltaW_limb_des = 0.45;       % width of normalized bell curve in descending branch (Moerl et al., 2012), adapted to match observed force-length curves in Kistemaker2006
MP.CE.DeltaW_limb_asc = 0.45;       % width of normalized bell curve in ascending branch (Moerl et al., 2012), adapted to match observed force-length curves in Kistemaker2006
MP.CE.v_CElimb_des = 1.5;           % exponent for descending branch (Moerl et al., 2012)
MP.CE.v_CElimb_asc = 3.0;           % exponent for ascending branch (Moerl et al., 2012)
MP.CE.A_rel0 = 0.2;                % parameter for contraction dynamics: maximum value of A_rel (Guenther, 1997, S. 82)
MP.CE.B_rel0 = 2.0;                % parameter for contraction dynmacis: maximum value of B_rel (Guenther, 1997, S. 82)
% eccentric force-velocity relation:
MP.CE.S_eccentric  = 2;             % relation between F(v) slopes at v_CE=0 (van Soest & Bobbert, 1993)
MP.CE.F_eccentric  = 1.5;           % factor by which the force can exceed F_isom for large eccentric velocities (van Soest & Bobbert, 1993)

% paralel elastic element (PEE)
%===============================

MP.PEE.L_PEE0   = 0.95;                               % rest length of PEE normalized to optimal lenght of CE %source? (Guenther et al., 2007)
MP.PEE.l_PEE0   = MP.PEE.L_PEE0*MP.CE.l_CEopt;       % rest length of PEE (Guenther et al., 2007)
MP.PEE.v_PEE    = 2.5;                               % exponent of F_PEE (Moerl et al., 2012)
MP.PEE.F_PEE    = 2.0;                               % force of PEE if l_CE is stretched to deltaWlimb_des (Moerl et al., 2012)
MP.PEE.K_PEE    = MP.PEE.F_PEE*( MP.CE.F_max/ ( MP.CE.l_CEopt*(MP.CE.DeltaW_limb_des+1-MP.PEE.L_PEE0) )^MP.PEE.v_PEE );
% factor of non-linearity in F_PEE (Guenther et al., 2007)

% serial damping element (SDE)
%=============================
MP.SDE.D_SE    = 0.3;               % dimensionless factor to scale d_SEmax (Moerl et al., 2012)
MP.SDE.R_SE    = 0.01;              % minimum value of d_SE normalised to d_SEmax (Moerl et al., 2012)
MP.SDE.d_SEmax = MP.SDE.D_SE*(MP.CE.F_max*MP.CE.A_rel0)/(MP.CE.l_CEopt*MP.CE.B_rel0);
% maximum value in d_SE in [Ns/m] (Moerl et al., 2012)

% serial elastic element (SEE)
% ============================
MP.SEE.DeltaU_SEEnll = 0.0425;          % relativ stretch at non-linear linear transition (Moerl et al., 2012)
MP.SEE.DeltaU_SEEl   = 0.017;           % relativ additional stretch in the linear part providing a force increase of deltaF_SEE0 (Moerl, 2012)
MP.SEE.DeltaF_SEE0   = MP.CE.F_max*0.4; % both force at the transition and force increase in the linear part in [N]

MP.SEE.l_SEEnll      = (1 + MP.SEE.DeltaU_SEEnll)*MP.SEE.l_SEE0;
MP.SEE.v_SEE         = MP.SEE.DeltaU_SEEnll/MP.SEE.DeltaU_SEEl;
MP.SEE.KSEEnl        = MP.SEE.DeltaF_SEE0 / (MP.SEE.DeltaU_SEEnll*MP.SEE.l_SEE0)^MP.SEE.v_SEE;
MP.SEE.KSEEl         = MP.SEE.DeltaF_SEE0 / (MP.SEE.DeltaU_SEEl*MP.SEE.l_SEE0);

% technical parameters for model
% ==============================
% the following parameters are required to allow the calculation of lever
% arms in the init and EP optimization. For this a specific muscle force
% needs to be defined
MP.f_MTU_fixed_switch = 0;
MP.f_MTU_fixed = nan;

end
