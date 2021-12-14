%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File to Run Ode Solver for the Steady 
% state ODE and save a times series plot as a figure
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CLEAR THE WORKSPACE

close all
clear all

% Set 1 if want to save figure and set 0 if do not want to save figure

savefigure = 0; 

% Set paramets values

R = 0.8;          % Initial active receptors 
k1plus = 1/10;   % GBgamma
k2plus = 1/12;   % GBPC
k3plus = 1/9;    % MCOR
k4plus = 1/16;   % RasB

k1minus = 1/120;    % GBgamma  
k2minus = 1/130;    % GBPC
k3minus = 1/145;    % MCOR
k4minus = 1/160;    % RasB
k5minus = 1/115;    % MHCKA

% Calculate k5plus as a function of time

k5plus = 1/11;   % MHCKA
a = .001;
tSteadyState = 100;
k5plus_fun = @(t) kfiveplus(t, k5plus, a, tSteadyState);

% Steady State Solutions

GBG = (k1plus*R)/(k1plus*R+k1minus);   % Steady State eq (G beta gamma)
GBPC =  (k2plus*GBG)/(k2plus*GBG+k2minus);  % Steady State eq (GBPC)
RASB =  (k4plus*GBG)/(k4plus*GBG-k4minus);  % Steady State eq (RASB)
MHCKASS = (k5plus*RASB)/(k5plus*RASB+k5minus);
MCORSS = (k3plus*GBPC)/(k3plus*GBPC+k3minus*MHCKASS);


% Put parameter values into vector

params = [k3plus, k3minus, k5minus];

% Set time span

tspan = [100 150];

% Set initial conditions

init_cond = [MHCKASS MCORSS];

% Run Ode Solver

[T,y] = ode45(@(t,Y) blebSolverSteadyStates(t,Y, k5plus_fun, params, GBPC, RASB) , tspan ,...
    init_cond);

% Plot solutions

y(end,:)

figure(1)

plot(T,y, 'linewidth', 2)

title("Time Versus Concentrations MCOR", 'FontSize', 20)
xlabel("Time (Seconds)",'FontSize', 17)
ylabel("Concentrations",'FontSize', 17)

legend('MCOR', 'MHCKA','location','southeast')

% figure(2)
% 
% plot(T,y(:,2), 'linewidth', 2)
% 
% title("Time Versus Concentrations MHCKA", 'FontSize', 20)
% xlabel("Time (Seconds)",'FontSize', 17)
% ylabel("Concentrations",'FontSize', 17)


% Save Time Series Plot as JPG File in a Folder with the
% Date

if savefigure == 1
    
    DateDay = datestr(now, 'dd-mmm-yyyy'); % Get current date
    
    DateTime = datestr(now, 'HH:MM:SS'); % Get current time
    
    if ~exist(DateDay, 'dir')
        
       mkdir(DateDay) % Make a Directory with the Current Date if it does not already exist
       
    end
    
    fileName = strcat('/Figure', DateTime ,'.jpg'); % Name figure file name based on current time
    
    dirPath = strcat('/',DateDay, fileName); % Directory Path
    
    saveas(figure(1),[pwd dirPath]); % Save Figure in Folder
  

end