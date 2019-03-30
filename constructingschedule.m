%% Constructing a schedule from a given sequence
function sch = constructingschedule(X,st)
global Jobsinfo;
X = X';
for j=1:size(X,1);
    X(j,2) = st;
    X(j,3) = Jobsinfo(X(j,1),2);
    X(j,4) = X(j,2) +X(j,3);
    X(j+1:size(X,1),2) = X(j,4);
    X(j,5) = Jobsinfo(X(j,1),3);
    X(j,6) = max(0,(X(j,4)-X(j,5)));    %% Tardiness
    X(j,7) = X(j,4)-X(j,5);                  %%Lateness
    st = X(j,4);
end
sch=X;
clear st;
end