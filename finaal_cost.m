function y = finaal_cost(n,res,down)     %% n: actual schedule --> column vector, res: number of rescheduling times
global first_schedule
global tardiness_coefficient; global inventory_coefficient; global expediting_coefficient
new_schedule = n;  
comput = 500*res;    %% Computational cost rate.
hc = 5 *inventory_coefficient;        %% Inventory cost rate.
exp = 25*expediting_coefficient;       %% Expediting cost rate.
tard = 10*tardiness_coefficient;      %% Tardiness cost --> assumed constant for all jobs temporarily.
[~, iI,iN] = intersect(first_schedule(:,1),new_schedule(:,1),'stable');   %% Getting indices of common jobs in both new and initial schedules.
holding = down*hc;
ee = first_schedule(iI,2) - new_schedule(iN,2);        %% Expediting time due to rescheduling.
expediting = sum(ee(ee>0))*exp;     %% Material Expediting cost.
tardiness = sum(new_schedule(:,6))*tard;     %% Cost of extra tardiness due to rescheduling
early = new_schedule( new_schedule(:,7) < 0,7);
earliness = sum(early)*-1;     %% Cost of holding early jobs
earliness_cost = earliness*hc;
y = comput + holding + expediting + tardiness +earliness_cost;    %% Total cost function
