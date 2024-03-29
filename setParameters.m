function [R, lengthScale, d, deltaT, final_time,...
    k1plus, alpha, k2plus, k3plus, k4plus, k5plus, k3minus,...
    k1minus, beta, k2minus, k4minus, k5minus, k6minus, k_0, myxlim] = setParameters()
%SETPARAMETERS has no inputs and returns the set parameter values

% Set paramets values
R = 0.8;                         % Initial active receptors 
lengthScale = 2.725;             % Diffusion length scale
sigma = 7.4;                     % sigma
d = .011;                        % Diffusion Rate
deltaT = 0.0026;%.01;            % Time Step
final_time = 13;                 % Final Time
k1plus = 1/10;                   % GBgamma
alpha = 15;                      % alpha
k2plus = alpha*k1plus;           % GBPC
k3plus = alpha*k1plus;           % MCOR
k4plus = alpha*k1plus;           % RasB
k5plus = alpha*k1plus;           % MHCKA
k3minus = alpha*k1plus;          % MCOR
k1minus = 1/120;                 % GBgamma  
beta = sigma*alpha;              % beta
k2minus = beta*k1minus;          % GBPC
k4minus = beta*k1minus;          % RasB
k5minus = beta*k1minus;          % MHCKA
k6minus = beta*k1minus;          % MCOR degradation
k_0 = 0.025;                     % RasB effect on MHCKA
myxlim = [0 final_time];         % xlimits for graph

end

