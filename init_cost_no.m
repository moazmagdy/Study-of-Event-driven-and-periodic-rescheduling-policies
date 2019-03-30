function y = init_cost_no(n,d)     %% n: new sequence --> column vector, d: is delays due to breakdown
global start_schedule

new_schedule = constructingschedule(n,start_schedule);  %% constructing schedule for the new sequence.
comput = 50;    %% Computational cost rate.
tard = 12;      %% Tardiness cost --> assumed constant for all jobs temporarily.
icost = 6;      %% Idle time cost rate.
idle = sum(d) * icost;   %% Cost of idle time
tardiness = sum(new_schedule(:,6))*tard;     %% Cost of extra tardiness due to rescheduling
y = comput + tardiness + idle;