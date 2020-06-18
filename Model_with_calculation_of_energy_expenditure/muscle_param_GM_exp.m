% This function initializes the muscle parameters
%
% If you use this model for scientific purposes, please cite our article.


% Copyright (c) 2019 belongs to D. Haeufle, and S. Schmitt 
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

function MP = muscle_param_GM_exp

%% Measured values
MP.CE.volume  = 379.89e-6;           % [m^3] Measurement
MP.CE.l_CEopt = 0.0574;              % [m] Optimal length of muscle fibres [Measurement]
MP.CE.pen0    = 27;                  % [deg] Fiber pennation angle  [Measurement]
MP.leverarm = -0.064;                % [m] lever arm around ankle joint [Measurement]
MP.l_MTU_ref = 0.315;                % [m] MTU length at reference joint angle [Measurement]

%% Muscle Parameters from literature
% contractile element
%===============================
MP.CE.muscle_tension = 0.25*10^6;    % Umberger et al. (2003) [N*m^-1]
MP.CE.PCSA = (MP.CE.volume/MP.CE.l_CEopt)*cos(MP.CE.pen0*pi/180); % Physiological cross sectional area
MP.CE.F_max = MP.CE.muscle_tension * MP.CE.PCSA;   % MP.E.PCSA * MP.E.muscle_tension
MP.CE.FT = 0.45;                    % Saltin, B., & Gollnick, P. D. (1983)
MP.CE.A_rel0 = 0.1 + 0.4*MP.CE.FT;  % Umberger et al. (2003)
MP.CE.B_rel0 = MP.CE.A_rel0*12;     % Umberger et al. (2003)
MP.CE.V_max_norm = 12;              % Umberger et al. (2003)
MP.CE.DeltaW_limb_des = 0.35;       % 0.35 width of normalized bell curve in descending branch (Moerl et al., 2012)
MP.CE.DeltaW_limb_asc = 0.35;       % 0.35 width of normalized bell curve in ascending branch (Moerl et al., 2012)
MP.CE.v_CElimb_des = 1.5;           % exponent for descending branch Cat(Moerl et al., 2012)
MP.CE.v_CElimb_asc = 3.0;           % exponent for ascending branch Cat (Moerl et al., 2012)
% eccentric force-velocity relation:
MP.CE.S_eccentric  = 2;             % relation between F(v) slopes at v_CE=0 (van Soest & Bobbert, 1993)
MP.CE.F_eccentric  = 1.5;           % factor by which the force can exceed F_isom for large eccentric velocities (van Soest & Bobbert, 1993)

% Energy calculation
%===============================
MP.E.hAM = (1.28*MP.CE.FT)+25;      % Umberger et al. (2003)
MP.E.S = 1;                         % Umberger et al. (2003)
MP.E.AlphaST = 100/MP.CE.V_max_norm;% Umberger et al. (2003)
MP.E.AlphaFT = 153/MP.CE.V_max_norm;% Umberger et al. (2003)
MP.E.AlphaL = 4*MP.E.AlphaST;       % Umberger et al. (2003)
MP.E.muscle_density = 1059.7;       % Umberger et al. (2003) [kg*m^-3]
MP.E.PCSA = MP.CE.PCSA;

% paralel elastic element (PEE)
%===============================
MP.PEE.L_PEE0   = 0.9;                               % rest length of PEE normalized to optimal lenght of CE (Guenther et al., 2007)
MP.PEE.l_PEE0   = MP.PEE.L_PEE0*MP.CE.l_CEopt;       % rest length of PEE (Guenther et al., 2007)
MP.PEE.v_PEE    = 2.5;                               % exponent of F_PEE (Moerl et al., 2012)
MP.PEE.F_PEE    = 2.0;                               % force of PEE if l_CE is stretched to deltaWlimb_des (Moerl et al., 2012)
MP.PEE.K_PEE    = MP.PEE.F_PEE*( MP.CE.F_max/ ( MP.CE.l_CEopt*(MP.CE.DeltaW_limb_des+1-MP.PEE.L_PEE0) )^MP.PEE.v_PEE ) ;                                 
                                                      % factor of non-linearity in F_PEE (Guenther et al., 2007)
                                                      
% serial damping element (SDE)
%=============================
MP.SDE.D_SE    = 0.3;               % xxx dimensionless factor to scale d_SEmax (Moerl et al., 2012)
MP.SDE.R_SE    = 0.01;              % minimum value of d_SE normalised to d_SEmax (Moerl et al., 2012)
MP.SDE.d_SEmax = MP.SDE.D_SE*(MP.CE.F_max*MP.CE.A_rel0)/(MP.CE.l_CEopt*MP.CE.B_rel0);
                                    % maximum value in d_SE in [Ns/m] (Moerl et al., 2012)

% serial elastic element (SEE)
% ============================
MP.SEE.l_SEE0        = MP.l_MTU_ref - MP.CE.l_CEopt;       % rest length of SEE in [m];
MP.SEE.DeltaU_SEEnll = 0.0425;      % relativ stretch at non-linear linear transition (Moerl et al., 2012)
MP.SEE.DeltaU_SEEl   = 0.017;       % relativ additional stretch in the linear part providing a force increase of deltaF_SEE0 (Moerl, 2012)
MP.SEE.DeltaF_SEE0   = 0.4*MP.CE.F_max;       % both force at the transition and force increase in the linear part in [N] (~ 40% of the maximal isometric muscle force)

MP.SEE.l_SEEnll      = (1 + MP.SEE.DeltaU_SEEnll)*MP.SEE.l_SEE0; % Haeufle et al (2014)
MP.SEE.v_SEE         = MP.SEE.DeltaU_SEEnll/MP.SEE.DeltaU_SEEl; % Haeufle et al (2014)
MP.SEE.KSEEnl        = MP.SEE.DeltaF_SEE0 / (MP.SEE.DeltaU_SEEnll*MP.SEE.l_SEE0)^MP.SEE.v_SEE; % Haeufle et al (2014)
MP.SEE.KSEEl         = MP.SEE.DeltaF_SEE0 / (MP.SEE.DeltaU_SEEl*MP.SEE.l_SEE0); % Haeufle et al (2014)
MP.SEE.KSEE          = MP.CE.F_max/((0.04*MP.SEE.l_SEE0)^2); % Haeufle et al (2014)

% Activation dynamics
% ============================

MP.act_dyn.c2 = (1/(0.090-0.056*MP.CE.FT)); % (Umberger et al. 2003)
MP.act_dyn.c1 = (1/(0.080-(0.047*MP.CE.FT)))-MP.act_dyn.c2; % (Umberger et al. 2003)


disp('*** Muscle parameters loaded ***');
end
