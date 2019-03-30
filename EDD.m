%% Earliest due date dispatching rule
function z = EDD(X)
global Jobsinfo;
M(:,1) = X;
M(:,2) = Jobsinfo(X(:,1),3);
[~,d] = sort(M(:,2));
M = M(d,:);
z = M(:,1);