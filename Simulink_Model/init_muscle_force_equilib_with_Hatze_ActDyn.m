

function [F_sum, F_SEE] = init_muscle_force_equilib_with_Hatze_ActDyn(l_CE, l_MTC, u, MusParam, ActParam)

l_CE_norm = l_CE/MusParam.CE.l_CEopt;

rho = ActParam.c * ActParam.eta * l_CE_norm * (ActParam.k-1) / (ActParam.k-l_CE_norm);
a   = (ActParam.q_0+(rho*u)^ActParam.nu) / (1+(rho*u)^ActParam.nu);

% Guenther et al. 2007
if l_CE >= MusParam.CE.l_CEopt %descending branch
    F_isom = exp( - ( abs( ((l_CE_norm)-1)/MusParam.CE.DeltaW_limb_des ) )^MusParam.CE.v_CElimb_des );
else %ascending branch
    F_isom = exp( - ( abs( ((l_CE_norm)-1)/MusParam.CE.DeltaW_limb_asc ) )^MusParam.CE.v_CElimb_asc );
end

% Force of the parallel elastic element
if l_CE >= MusParam.PEE.l_PEE0
    F_PEE = MusParam.PEE.K_PEE*(l_CE-MusParam.PEE.l_PEE0)^(MusParam.PEE.v_PEE);
else % shorter than slack length
    F_PEE = 0;
end

% Force of the serial elastic element (SEE)
l_SEE = abs(l_MTC-l_CE);
% Guenther et al. 2007
if (l_SEE>MusParam.SEE.l_SEE0) && (l_SEE<MusParam.SEE.l_SEEnll) %non-linear part
    F_SEE = MusParam.SEE.KSEEnl*((l_SEE-MusParam.SEE.l_SEE0)^(MusParam.SEE.v_SEE));
elseif l_SEE>=MusParam.SEE.l_SEEnll %linear part
    F_SEE = MusParam.SEE.DeltaF_SEE0+MusParam.SEE.KSEEl*(l_SEE-MusParam.SEE.l_SEEnll);
else %salck length
    F_SEE = 0;
end

% Contractile element force (isometric)
F_CE = MusParam.CE.F_max * a * F_isom;

F_sum = F_SEE-F_CE-F_PEE;