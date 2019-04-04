%%Rescheduling function
function [y1 , y2] = reschedule(Y,t,a,initial_fit)    %% Y: schedule to be rescheduled, t: the rescheduling point, a: Objective function
global s;
sr = Y(Y(:,2) > t,1);        %% Identify jobs that start after disruption
S_res1 = Y(Y(:,2) <= t,:);
s = sr;
if size(sr,1) > 2
    start = S_res1(end,4);
    [secondary,cost] = Run_ABZ5_100_random(s,a,start,initial_fit);
    S_res2 = constructingschedule(secondary,S_res1(end,4));
    M = vertcat(S_res1,S_res2);
    M(:,6) = max(0, M(:,4) - M(:,5));
    M(:,7) =M(:,4) - M(:,5);
else
    g = EDD(s);
    S_res2 = constructingschedule(g',S_res1(end,4));
    M = vertcat(S_res1,S_res2);
    cost =0;
end
    y1 = M;
    y2 = cost;