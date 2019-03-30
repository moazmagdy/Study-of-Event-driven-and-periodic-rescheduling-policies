res_freq = 9;
nj =30;
pj = [54;57;29;57;47;28;35;44;59;59;31;59;59;42;53;30;40;57;53;59;48;26;55;58;49;52;51;39;48;31] ;
dj = [1024;71;417;91;163;1190;1008;474;1369;75;646;565;1108;1150;290;718;656;939;1028;1092;416;986;952;256;194;730;1382;507;853;342] ;
Jobsinfo(:,1)= 1:nj;
Jobsinfo(:,2) = pj;
Jobsinfo(:,3) = dj;
Breakdown_start = [ 0.3*sum(pj) 0 0 ; 0.25*sum(pj) 0.75*sum(pj) 0 ; 0.2*sum(pj) 0.55*sum(pj) 0.80*sum(pj)];
res_period = sum(pj) / (res_freq+1);            %% calculate the rescheduling period length.
res_point = res_period*[1:res_freq];            %%  caculate the rescheduling points.
scenarios
nbk = 20;
A = [ transpose(res_point), zeros(length(res_point),1)];
B = [transpose(Breakdown_start(scenario(nbk,1),1:scenario(nbk,1))), ones(scenario(nbk,1),1)];
Z = vertcat(A,B);
[q,w] = sort(Z(:,1));
Z = Z(w,:);             %% 0 = Rescheduling point, 1 = Disruption point
format shortG
for i = 1:size(Z,1)
    if Z(i,2) == 0
       
        disp('Rescheduling point')
    end
    if Z(i,2) ==1
        disp('Disruption point')
    end
end