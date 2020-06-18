% This is the main skript to prepare and run the simulation and plot the 
% results in comparison to the experimental data.
%

% If you use this model for scientific purposes, please cite our article.
%
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

clear

%% load data and parameters
init_muscle_exp

SimData=sim('Model_of_plantarflexions','SrcWorkspace','current','SimulationMode', 'normal');
%%
logsout = SimData.get('logsout');
energy = logsout.get('energy');
energy = energy.Values; %extract time series object
%%

%%
figure
hold all
plot(energy)

load experimental_data_energy.mat
errorbar(exp_data.time_s(24:34),Energy_exp,Energy_exp*0.1,'x')

%title('energy expanditure')
xlabel('time [s]')
ylabel('energy [W/kg]')
ylabel('energy [J/kg]')