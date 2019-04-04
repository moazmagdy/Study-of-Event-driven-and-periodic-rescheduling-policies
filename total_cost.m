function y = total_cost(x,start,initial_fit)     %% n: new sequence --> column vector, res: number of rescheduling times
global first_schedule
global tardiness_coefficient; global inventory_coefficient; global expediting_coefficient
new_schedule = constructingschedule(x,start); %% constructing schedule for the new sequence.
comput = 500;    %% Computational cost rate.
hc = 5 *inventory_coefficient;        %% Inventory cost rate.
exp = 25*expediting_coefficient;       %% Expediting cost rate.
tard = 10*tardiness_coefficient;      %% Tardiness cost --> assumed constant for all jobs temporarily.
[~, iI,iN] = intersect(first_schedule(:,1),new_schedule(:,1),'stable');   %% Getting indices of common jobs in both new and initial schedules.
if sum(sum(first_schedule)) == 0
    down_time = 0;
    expediting = 0;     %% Material Expediting cost.
else
    down_time = max(new_schedule(end,4) - first_schedule(end,4),0);   %% Down time due to breakdown.
    ee = first_schedule(iI,2) - new_schedule(iN,2);        %% Expediting time due to rescheduling.
    expediting = sum(ee(ee>0))*exp;     %% Material Expediting cost.
end
extraholding_cost = down_time*hc;   %% Cost of extra holding disrupted job.
early = new_schedule( new_schedule(:,7) < 0,7);
earliness = sum(early)*-1;     %% Cost of holding early jobs
earliness_cost = earliness*hc;
tardiness = (sum(new_schedule(:,6)))*tard; %% Cost of total tardiness due to rescheduling
y = comput + expediting + tardiness + extraholding_cost + earliness_cost+initial_fit ;   %% Total cost function