% This function inizializes the muscle tendon complex parameters to the
% matlab workspace.
%
% MUSCLE_PARAM_MUS01 returns a struct containing all parameters required
% for one muscle tendon complex.
%
% Revision 1.23, 25.02.2014
%
% References: 
%
% Guenther, M, S Schmitt, and V Wank. 2007. 'High-Frequency Oscillations as
% a Consequence of Neglected Serial Damping in Hill-Type Muscle Models.'
% Biological Cybernetics 97 (1) (July): 63-79.
% doi:10.1007/s00422-007-0160-6.
%
% Guenther, Michael. 1997. 'Computersimulationen Zur Synthetisierung Des
% Muskulatur Erzeugten Menschlichen Gehens Unter Verwendung Eines
% Biomechanischen Mehrkoerpermodells'. Eberhard-Karls-Universitaet 
% Tuebingen.
%
% Moerl, Falk, Tobias Siebert, Syn Schmitt, Reinhard Blickhan, and Michael
% Guenther. 2012. 'Electro-Mechanical Delay in Hill-Type Muscle Models.'
% Journal of Mechanics in Medicine and Biology 12 (05) (December): 1250085.
% doi:10.1142/S0219519412500856.
%
% Kistemaker, Dinant, Arthur J Van Soest, and Maarten F Bobbert. 2006.
% 'Is Equilibrium Point Control Feasible for Fast Goal-Directed
% Single-Joint Movements' Journal of Neurophysiology 95 (5) (May):
% 2898-912. doi:10.1152/jn.00983.2005.
%
% Van Soest, Arthur J., and Maarten F Bobbert. 1993. 'The Contribution of
% Muscle Properties in the Control of Explosive Movements.' Biological
% Cybernetics 69 (3) (July): 195-204. doi:10.1007/BF00198959.
%
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


function MP = muscle_param_mus01

% define muscle name
%===========================
MP.muscle_ID = 1;                   % this identifyer is used for error and warning messages

%% Muscle Parameters

% contractile element (CE)
%===========================
MP.CE.F_max = 1420;                 % F_max in [N] for Extensor (Kistemaker et al., 2006)
MP.CE.l_CEopt =0.092;               % optimal length of CE in [m] for Extensor (Kistemaker et al., 2006)
MP.CE.DeltaW_limb_des = 0.35;       % width of normalized bell curve in descending branch (Moerl et al., 2012)
MP.CE.DeltaW_limb_asc = 0.35;       % width of normalized bell curve in ascending branch (Moerl et al., 2012)
MP.CE.v_CElimb_des = 1.5;           % exponent for descending branch (Moerl et al., 2012)
MP.CE.v_CElimb_asc = 3.0;           % exponent for ascending branch (Moerl et al., 2012)
MP.CE.A_rel0 = 0.25;                % parameter for contraction dynamics: maximum value of A_rel (Guenther, 1997, S. 82)
MP.CE.B_rel0 = 2.25;                % parameter for contraction dynmacis: maximum value of B_rel (Guenther, 1997, S. 82)
% eccentric force-velocity relation:
MP.CE.S_eccentric  = 2;             % relation between F(v) slopes at v_CE=0 (van Soest & Bobbert, 1993)
MP.CE.F_eccentric  = 1.5;           % factor by which the force can exceed F_isom for large eccentric velocities (van Soest & Bobbert, 1993)

% paralel elastic element (PEE)
%===============================

MP.PEE.L_PEE0   = 0.9;                               % rest length of PEE normalized to optimal lenght of CE (Guenther et al., 2007)
MP.PEE.l_PEE0   = MP.PEE.L_PEE0*MP.CE.l_CEopt;       % rest length of PEE (Guenther et al., 2007)
MP.PEE.v_PEE    = 2.5;                               % exponent of F_PEE (Moerl et al., 2012)
MP.PEE.F_PEE    = 2.0;                               % force of PEE if l_CE is stretched to deltaWlimb_des (Moerl et al., 2012)
MP.PEE.K_PEE    = MP.PEE.F_PEE*( MP.CE.F_max/ ( MP.CE.l_CEopt*(MP.CE.DeltaW_limb_des+1-MP.PEE.L_PEE0) )^MP.PEE.v_PEE );
                                                     % factor of non-linearity in F_PEE (Guenther et al., 2007)

% serial damping element (SDE)
%=============================
MP.SDE.D_SE    = 0.3;               % xxx dimensionless factor to scale d_SEmax (Moerl et al., 2012)
MP.SDE.R_SE    = 0.01;              % minimum value of d_SE normalised to d_SEmax (Moerl et al., 2012)
MP.SDE.d_SEmax = MP.SDE.D_SE*(MP.CE.F_max*MP.CE.A_rel0)/(MP.CE.l_CEopt*MP.CE.B_rel0);
                                    % maximum value in d_SE in [Ns/m] (Moerl et al., 2012)

% serial elastic element (SEE)
% ============================
MP.SEE.l_SEE0        = 0.172;       % rest length of SEE in [m] (Kistemaker et al., 2006)
MP.SEE.DeltaU_SEEnll = 0.0425;      % relativ stretch at non-linear linear transition (Moerl et al., 2012)
MP.SEE.DeltaU_SEEl   = 0.017;       % relativ additional stretch in the linear part providing a force increase of deltaF_SEE0 (Moerl, 2012)
MP.SEE.DeltaF_SEE0   = 568;         % both force at the transition and force increase in the linear part in [N] (~ 40% of the maximal isometric muscle force)

MP.SEE.l_SEEnll      = (1 + MP.SEE.DeltaU_SEEnll)*MP.SEE.l_SEE0;
MP.SEE.v_SEE         = MP.SEE.DeltaU_SEEnll/MP.SEE.DeltaU_SEEl;
MP.SEE.KSEEnl        = MP.SEE.DeltaF_SEE0 / (MP.SEE.DeltaU_SEEnll*MP.SEE.l_SEE0)^MP.SEE.v_SEE;
MP.SEE.KSEEl         = MP.SEE.DeltaF_SEE0 / (MP.SEE.DeltaU_SEEl*MP.SEE.l_SEE0);


disp(['*** Muscle_' num2str(MP.muscle_ID) ' parameters loaded ***']);
end