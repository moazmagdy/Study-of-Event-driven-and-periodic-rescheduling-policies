%% Main (Both policies)
clc;
global Jobsinfo;global s; global first_schedule;global scenario; global tardiness_coefficient; global inventory_coefficient; global expediting_coefficient
tardiness_coefficient = 1; %%Coefficient used for sensitivity analysis
inventory_coefficient = 1;
expediting_coefficient = 1;
[num, Exp ,~] = xlsread('Rescheduling Experiment'); %% Reads data of experiment from Excel file (Rescheduling Experiment) in the same folder
[Job10, ~ ,~] = xlsread('10 Jobs Info'); %% Reads jobs data for 10 job experiment.
[Job25 ,~, ~] = xlsread('25 job Info'); %% Reads jobs data for 25 job experiment.
results_tardiness = zeros(7680,1);  %% preallocation for algorithm sp1d
results_cost = zeros(7680,1);
initial_tardiness = zeros(7680,1);
results_lateness = zeros(7680,1) ;
initial_lateness = zeros(7680,1) ;
results_earliness = zeros(7680,1);
level = 2;  %% Due dates tightness level: 1 --> loose, 2 --> Normal, 3 --> Tight
first_schedule = zeros(25,6);   %% This schedule will be used for total cost objective
for j = 800
    j 
    [Jobsinfo, Breakdown_start, scenario ,policy,obj] = trial(j,Job10,Job25,num,Exp,level);
        %% Event-drive policy
        if policy == 1
            s = Jobsinfo(:,1);
            start =0;
            initial_fit =0;
            [bestseq,bestvalue] = Run_ABZ5_100_random(s,obj,start,initial_fit);
            initial_fit = bestvalue;
            schedule_initial = constructingschedule(bestseq,0);
            first_schedule = schedule_initial;
            for dwn = 1:size(scenario,2)    %% dwn is breakdown number in scenarios matrix
                [new_schedule, result ]= event_driven(schedule_initial,Breakdown_start(dwn),dwn,obj,initial_fit);
                initial_fit = result;
                schedule_initial = new_schedule;
            end
            if isempty(scenario) == 1
                Act_schedule = first_schedule;
            else
                Act_schedule = new_schedule;
            end
            final_cost = finaal_cost(Act_schedule,size(scenario,2),sum(scenario));      %% Total cost due to rescheduling decision.
            %% No-rescheduling policy
        elseif policy == 5
            s = Jobsinfo(:,1);
            start = 0;
            initial_fit =0;
            [bestseq,bestvalue] = Run_ABZ5_100_random(s,obj,start,initial_fit);
            Initial_seq = (bestseq)';
            schedule_initial = constructingschedule(bestseq,0);
            first_schedule = schedule_initial;
            dwn = 0;
            for ll = 1:size(scenario,2)
                dwn = dwn +1;
                schedule_initial = insertdis(schedule_initial,Breakdown_start(1,ll),dwn);
                bestvalue2 = 0 ;
            end
            Act_schedule = [];
            Act_schedule = schedule_initial;
            final_cost = finaal_cost(Act_schedule,0,sum(scenario));      %% Total cost due to rescheduling decision.
            %% Periodic policy
        else
            if policy == 2; frequency = 2;          %% Identifying rescheduling frequency
            elseif policy == 3; frequency = 3;
            elseif policy == 4; frequency = 4;
            elseif policy == 6; frequency = 6;
            elseif policy == 8; frequency = 8;
            elseif policy == 10; frequency =10;
            elseif policy == 20; frequency = 20;
            end
            res_freq = frequency;
            res_period = sum(Jobsinfo(:,2)) / (res_freq+1);            %% calculate the rescheduling period length.
            res_point = double.empty([1,50,0]);
            res_point = res_period*[1:res_freq];            %%  caculate the rescheduling points.
            
            s = Jobsinfo(:,1);
            start =0;
            initial_fit =0;
            [bestseq,bestvalue] = Run_ABZ5_100_random(s,obj,start,initial_fit);
            initial_fit = bestvalue;
            Initial_seq = (bestseq)';
            schedule_initial = constructingschedule(bestseq,0);
            first_schedule = schedule_initial;
            A = [ transpose(res_point), zeros(length(res_point),1)];
            B = [transpose(Breakdown_start), ones(size(Breakdown_start,2),1)];
            if Breakdown_start == 0
                Z = A;
            else
                Z = vertcat(A,B);
            end
            [q,w] = sort(Z(:,1));
            Z = Z(w,:);             %% Binary vector: 0 = Rescheduling point, 1 = Disruption point
            dwn = 0;
            for i = 1:size(Z,1)
                if Z(i,2) == 0      %% Check if the current point is rescheduling point
                    [schedule_initial, result] = reschedule(schedule_initial,Z(i,1),obj,initial_fit);
                    initial_fit = result;
                elseif  Z(i,2) ==1       %% Check if the current point is disruption point
                    dwn = dwn +1;
                    schedule_initial = insertdis(schedule_initial,Z(i,1),dwn);
                end
            end
            Act_schedule = [];
            Act_schedule = schedule_initial;
            final_cost = finaal_cost(Act_schedule,frequency,sum(scenario));
        end
        if isempty(scenario) == 1 &&  (policy == 5 || policy == 1)
            Act_schedule = first_schedule;
        end
        %% Recording results
        results_tardiness(j,1) = sum(Act_schedule(:,6));
        initial_tardiness(j,1) = sum(first_schedule(:,6));
        results_cost(j,1) = sum(final_cost);
        results_lateness(j,1) = sum(Act_schedule(:,7));
        initial_lateness(j,1) = sum(first_schedule(:,7));
        results_earliness(j,1) = sum(Act_schedule(:,7));
        schedule_initial = [];
        final_cost=[];
end
beep