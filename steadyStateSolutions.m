%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File to Run Ode Solver and look at the steady states
% when changing variables
% Varaible changed: R0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CLEAR THE WORKSPACE

close all
clear all

% Set paramets values

R = (0:.1:1);          % Initial active receptors 
alpha1 = 1/10;   % GBgamma
alpha2 = 1/12;   % GBPC
alpha3 = 1/9;    % MCOR
alpha4 = 1/16;   % RasB
alpha5 = 1/11;   % MHCKA

k1 = 1/120;    % GBgamma  
k2 = 1/130;    % GBPC
k3 = 1/145;    % MCOR
k4 = 1/160;    % RasB
k5 = 1/115;    % MHCKA

savefigure = 1; % Set 1 if want to save figure and set 0 if do not want to save figure

% Put parameter values into vector

params = [alpha1, alpha2, alpha3, alpha4, alpha5, ...
    k1, k2, k3, k4, k5];

% Set time span

tspan = [0 120];

% Set initial conditions

init_cond = [.5 0 0 0 0];

% Pre-allocate Space in SSsolns vector

SSsolns = zeros(length(R), length(init_cond));

% Run Ode Solver in loop for various R0 values

for i = 1:length(R)
    
    [T,y] = ode45(@(t,Y) blebSolver(t,Y,R(i),params) , tspan ,...
    init_cond);

    % Save Steady State Solutions 

    
    SSsolns(i, :) = y(end); 


end

VarNames = {'R_0', 'GBG Steady State', 'GBPC Steady State', 'MCOR Steady State',...
        'RASB Steady State', 'MHCKA Steady State'};

steady_state_table = table(R', SSsolns(:,1),SSsolns(:,2),SSsolns(:,3)...
    ,SSsolns(:,4),SSsolns(:,5), 'VariableNames',VarNames)

