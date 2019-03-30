%% Event-driven rescheduling function
function [y1 ,y2]= event_driven(Q,f,dwn,O,initial_fit)  %% Q: initial schedule, f: disruption start time, dwn: Disruption number, O: Objective function
global scenario;
global s;
if isempty(scenario) == 1
    scenario(1,dwn) = 0;
end
SS1 = Q(Q(:,2) <= f , :);   %% Identify jobs till disrupted job.
SS1(end,4) = SS1(end,4) + scenario(1,dwn);      %% Add downtime to completion time of disrupted job.
SS1(end,6) = max(0, SS1(end,4) - SS1(end,5));   %% calculate updated tardiness of the disrupted job.
SS1(end,7) = SS1(end,4) - SS1(end,5);              %% Calculate updated lateness of the disrupted job.
SS2 = Q(Q(:,2) > f , :);
s = SS2(:,1); 
        if size (SS2,1) > 2
            start= SS1(end,4);
            [sequence,fit] = Run_ABZ5_100_random(s,O,start,initial_fit);
            SS2  = constructingschedule(sequence,SS1(end,4));
            CS = vertcat(SS1,SS2);
            CS(:,6) = max(0, CS(:,4) - CS(:,5));
        else
            s = EDD(s);
            fit = initial_fit*1.05;
            SS2  = constructingschedule(s',SS1(end,4));
            CS = vertcat(SS1,SS2);
            CS(:,6) = max(0, CS(:,4) - CS(:,5));
        end
        s=[];
y1 = CS;
y2= fit;
