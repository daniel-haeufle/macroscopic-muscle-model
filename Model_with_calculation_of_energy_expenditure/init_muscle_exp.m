% init_muscle_exp initializes all parameters necessary for the simulation
% of the plantarflexion movements.

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

%% load experimental data of the plantarflexion exercise

%------angle----------
load experimental_data_ankle_angle_60sec.mat
ankle_angle_60sec = deg2rad(ankle_angle_60sec);

%------time----------
load experimental_data_Time.mat

%------EMG----------
% normalized to MVC
load experimental_data_gm_norm_MVC.mat

%% Load muscle parameters

MP = muscle_param_GM_exp;

%% Specify initial conditions
% Before the muscle model can be initialized, the length of the MTU at t=0
% and the initial muscle activity have to be defined:

MP.l_MTU_init = MP.leverarm * ankle_angle_60sec(1) + MP.l_MTU_ref;   % [m] length of muscle at initial pedal angle

MP.a_CE_init  = gm_norm_MVC(1);                                    % [] initial muscle activity;

% initial condition for internal degree of freedom (l_CE)
% the initial condition MP.l_CE_init is found under the assumtion that 
% all velocities are zero at the beginning of the simulation and that the
% force-equilibrium is F_SEE - F_CE - F_PEE = 0. The root is found with
% fzero

fhandle         = @(l_CE)init_muscle_force_equilib(l_CE, MP.l_MTU_init, MP.a_CE_init, MP);
MP.l_CE_init = fzero(fhandle, [0 MP.l_MTU_init]);
clear fhandle
