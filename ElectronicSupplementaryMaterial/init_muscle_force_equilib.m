% init_muscle_force_equilib calculates the sum of all forces in the MTC
% model. This function is required to identify l_CE length with
% force-equilibrium at the internal degree of freedom. It is used to
% calculate the initial conditions (integrator constant) for dot_l_CE. 
%
% Any changes to the MTC model's force equation have to be applied here
% too.
%
%
% Revision 1.23, 25.02.2014
%
% If you use this model for scientific purposes, please cite our article:
% D.F.B. Haeufle, M. Günther, A. Bayer, S. Schmitt (2014) Hill-type muscle
% model with serial damping and eccentric force-velocity relation Journal
% of Biomechanics http://dx.doi.org/10.1016/j.jbiomech.2014.02.009


% Copyright (c) 2014 belongs to D. Haeufle, M. Guenther, A. Bayer, and S.
% Schmitt 
% All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%  1 Redistributions of source code must retain the above copyright notice,
%    this list of conditions and the following disclaimer. 
%  2 Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
%  3 Neither the name of the owner nor the names of its contributors may be
%    used to endorse or promote products derived from this software without
%    specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
% THE POSSIBILITY OF SUCH DAMAGE.


function [F_sum] = init_muscle_force_equilib(l_CE, l_MTC, q, Mus_Param)

% Isometric force (Force length relation)
%Guenther et al. 2007
if l_CE >= Mus_Param.CE.l_CEopt %descending branch
    F_isom = exp( - ( abs( ((l_CE/Mus_Param.CE.l_CEopt)-1)/Mus_Param.CE.DeltaW_limb_des ) )^Mus_Param.CE.v_CElimb_des );
else %ascending branch
    F_isom = exp( -( abs( ((l_CE/Mus_Param.CE.l_CEopt)-1)/Mus_Param.CE.DeltaW_limb_asc ) )^Mus_Param.CE.v_CElimb_asc );
end

% Force of the parallel elastic element
if l_CE >= Mus_Param.PEE.l_PEE0
    F_PEE = Mus_Param.PEE.K_PEE*(l_CE-Mus_Param.PEE.l_PEE0)^(Mus_Param.PEE.v_PEE);
else % shorter than slack length
    F_PEE = 0;
end

% Force of the serial elastic element
l_SEE = abs(l_MTC-l_CE);
if (l_SEE>Mus_Param.SEE.l_SEE0) && (l_SEE<Mus_Param.SEE.l_SEEnll) %non-linear part
    F_SEE = Mus_Param.SEE.KSEEnl*((l_SEE-Mus_Param.SEE.l_SEE0)^(Mus_Param.SEE.v_SEE));
elseif l_SEE>=Mus_Param.SEE.l_SEEnll %linear part
    F_SEE = Mus_Param.SEE.DeltaF_SEE0+Mus_Param.SEE.KSEEl*(l_SEE-Mus_Param.SEE.l_SEEnll);
else %salck length
    F_SEE = 0;
end

% Contractile element force (isometric)
F_CE = Mus_Param.CE.F_max*q*F_isom;

F_sum = F_SEE-F_CE-F_PEE;