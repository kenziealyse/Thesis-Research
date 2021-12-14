%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File to Run Ode Solver and save a times series plot as a figure
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%chanign
% CLEAR THE WORKSPACE

close all
clear all

% Set paramets values

R = 0.8;          % Initial active receptors 
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

k5plus = 1/11;   % MHCKA
a = .5;
tSteadyState = 100;
k5plus_fun = @(t) kfiveplus(t, k5plus, a, tSteadyState);


savefigure = 1; % Set 1 if want to save figure and set 0 if do not want to save figure

% Put parameter values into vector

params = [alpha1, alpha2, alpha3, alpha4, alpha5, ...
    k1, k2, k3, k4, k5];

% Set time span

tspan = [0 200];

% Set initial conditions

init_cond = [.5 0 0 0 0];

% Run Ode Solver

[T,y] = ode45(@(t,Y) blebSolver(t,Y,R,params, k5plus_fun) , tspan ,...
    init_cond);


% Plot solutions

figure(1)

plot(T,y, 'linewidth', 2)

title("Time Versus Concentrations", 'FontSize', 20)
xlabel("Time (Seconds)",'FontSize', 17)
ylabel("Concentrations",'FontSize', 17)

legend('GBG', 'GBPC', 'MCOR', 'RasB', 'MHCKA','location','southeast')

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