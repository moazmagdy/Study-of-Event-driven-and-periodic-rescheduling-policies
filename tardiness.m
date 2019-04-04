%% Minimum total tardniess as an objective function
function z = tardiness(x,start,initial_fit)
global Jobsinfo;
st = start;
x =x';

for j=1:size(x,1)
    x(j,2) =st;
    x(j,3) = Jobsinfo(x(j,1),2);
    x(j,4) = x(j,2) +x(j,3);
    x(j+1:end,2) = x(j,4);
    x(j,5) = Jobsinfo(x(j,1),3);
    x(j,6) = max(0,(x(j,4)-x(j,5)));
    st = x(j,4);
    
end
z = sum(x(:,6))+initial_fit;

end

