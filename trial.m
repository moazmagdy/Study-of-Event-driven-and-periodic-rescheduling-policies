function [x1, x2, x3, x4,x5] = trial(i,Job10,Job25,num,Exp,level)
rng('shuffle')
a1 = num(i,3);  %% Assign jobs processing time and due dates according to problem size.
if a1 == 10     %% a1 is problem size
    pj = Job10(:,1); dj =Job10(:,level+1);
elseif a1 == 25
    pj = Job25(:,1); dj=Job25(:,level+1);
end
Jobsinfo(:,1)= 1:a1;
Jobsinfo(:,2) = pj;
Jobsinfo(:,3) = dj;
processing_time = sum(pj);
a2 = Exp(i,4);  %% Assign level of disruption length.
x = strcmpi(a2,'Short');    %% Identify length of disruption
a3 = num(i,1);  %% a3 is the number of disruptions
if x == 1
    bd = round((0.02+(0.04-0.02)*rand(1,a3))*processing_time,2); %% Assign value between [0.02 , 0.04]M to breakdown length.
else
    bd = round((0.07+(0.14-0.07)*rand(1,a3))*processing_time,2); %% Assign value between [0.07 , 0.14]M to breakdown length.
end
scenario = [bd];
M = (bd*a3)+processing_time;     %% Schedule makespan
M = mean(M);
%% All possible breakdown start time
Breakdown_matrix = zeros(7,3);
Breakdown_matrix(2,:) = [(0.05+(0.35-0.05)*rand(1))*M (0.35+(0.65-0.35)*rand(1))*M (0.65+(0.95-0.65)*rand(1))*M];
Breakdown_matrix(3:4,:) = [ (0.05+(0.35-0.05)*rand(2,1))*M (0.35+(0.65-0.35)*rand(2,1))*M (0.65+(0.95-0.65)*rand(2,1))*M];
Breakdown_matrix(5:7,:) = [ (0.05+(0.35-0.05)*rand(3,1))*M (0.35+(0.65-0.35)*rand(3,1))*M (0.65+(0.95-0.65)*rand(3,1))*M];
%% Generating break down start time matrix to work with old code
a4 = Exp(i,2);  %% a4 is time of disruption
if strcmpi(a4 , 'Early') == 1 && a3 == 0
    Breakdown_start = Breakdown_matrix(1,1);
elseif strcmpi(a4 , 'Early') == 1 && a3 == 1
    Breakdown_start = (Breakdown_matrix(2,1))';
elseif strcmpi(a4 ,'Early') == 1 && a3 == 2
    Breakdown_start = (Breakdown_matrix(3:4,1))';
elseif strcmpi(a4 ,'Early') == 1 && a3 == 3
    Breakdown_start = (Breakdown_matrix(5:7,1))';
end
if strcmpi(a4 , 'Middle') == 1 && a3 == 0
    Breakdown_start = Breakdown_matrix(1,2);
elseif strcmpi(a4 , 'Middle') == 1 && a3 == 1
    Breakdown_start = (Breakdown_matrix(2,2))';
elseif strcmpi(a4 ,'Middle') == 1 && a3 == 2
    Breakdown_start = (Breakdown_matrix(3:4,2))';
elseif strcmpi(a4 ,'Middle') == 1 && a3 == 3
    Breakdown_start = (Breakdown_matrix(5:7,2))';
end
if strcmpi(a4 , 'Late') == 1 && a3 == 0
    Breakdown_start = Breakdown_matrix(1,3);
elseif strcmpi(a4 , 'Late') == 1 && a3 == 1
    Breakdown_start = (Breakdown_matrix(2,3))';
elseif strcmpi(a4 ,'Late') == 1 && a3 == 2
    Breakdown_start = (Breakdown_matrix(3:4,3))';
elseif strcmpi(a4 ,'Late') == 1 && a3 == 3
    Breakdown_start = (Breakdown_matrix(5:7,3))';
end
%% Identifying rescheduling policy
policy = [];
if strcmpi('Event-driven',Exp(i,1)) == 1
    policy = 1;
elseif strcmpi('Periodic (r=2)',Exp(i,1)) == 1
    policy = 2;
elseif strcmpi('Periodic (r=4)',Exp(i,1)) == 1
    policy = 4;
elseif strcmpi('No rescheduling',Exp(i,1)) == 1
    policy = 5;
elseif strcmpi('Periodic (r=6)',Exp(i,1)) == 1
    policy = 6;
elseif strcmpi('Periodic (r=8)',Exp(i,1)) == 1
    policy = 8;
elseif strcmpi('Periodic (r=10)',Exp(i,1)) == 1
    policy = 10;
elseif strcmpi('Periodic (r=20)',Exp(i,1)) == 1
    policy = 20;
end
if strcmpi('Total Tardiness',Exp(i,6)) == 1
    obj = 1;
elseif strcmpi('Total Cost',Exp(i,6)) == 1
    obj = 0;
elseif strcmpi('Total Lateness',Exp(i,6)) == 1
    obj = 2;
end
Breakdown_start = sort(Breakdown_start);

x1 = Jobsinfo;
x2 = Breakdown_start;
x3 = scenario;
x4 = policy;
x5 = obj;
clear a1 a2 a3 a4 M
