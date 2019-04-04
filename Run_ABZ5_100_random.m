function [x,FVAL] =  Run_ABZ5_100_random(s,a,start,initial_fit)     %% Start: start of new schedule.
rng('shuffle')
%%   This is an auto generated M file to do optimization with the Genetic Algorithm and
%    Direct Search Toolbox. Use GAOPTIMSET for default GA options structure.
global Jobsinfo;
global pro;
global limited;
global limited_2;
global limited_3;
limited = start;
limited_2 = initial_fit;
limited_3 = a;
% global s;
pro =Jobsinfo(s(:,1),2);
%%Fitness function
if a == 1
fitnessFunction = @(x) tardiness(x,start,initial_fit);
elseif a == 2
    fitnessFunction = @(x) lateness(x,start,initial_fit);
elseif a == 0
    fitnessFunction = @(x) total_cost(x,start,initial_fit);
end
%%Number of Variables
nvars = size(s,1);
%Start with default options
options = gaoptimset;
%%Modify some parameters
options = gaoptimset(options,'PopulationType' ,'custom');
options = gaoptimset(options,'PopulationSize' ,50);
options = gaoptimset(options,'StallGenLimit' ,Inf);
options = gaoptimset(options,'StallTimeLimit' ,Inf);
options = gaoptimset(options,'MutationFcn' ,@mutationinversion_BM_MS);
options = gaoptimset(options,'Display' ,'off');
options = gaoptimset(options,'CreationFcn' ,@Create_BM_MS);
%%Run GA
options = gaoptimset(options,'CrossoverFcn' ,@crossover_besthybrid_BM_MS);
options = gaoptimset(options,'EliteCount' ,1);
options = gaoptimset(options,'CrossoverFraction' ,0.9);
options = gaoptimset(options,'Generations' ,2000);
[x,FVAL] = ga(fitnessFunction,nvars,options);



