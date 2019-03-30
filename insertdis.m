%% Disruption insertion function
%%  Q: Schedule before disruption, f: Disruption start time, dwn: Disruption number
function after_disruption = insertdis(Q,f,dwn)  
global scenario;
if isempty(scenario) == 1
    scenario(1,dwn) = 0;
end
SS1 = Q(Q(:,2) <= f , :);
SS1(end,4) = SS1(end,4) + scenario(1,dwn);
SS1(end,6) = max(0, SS1(end,4) - SS1(end,5));
SS2 = Q(Q(:,2) > f , 1);
SS2  = constructingschedule(SS2',SS1(end,4));
CS = vertcat(SS1,SS2);
CS(:,6) = max(0, CS(:,4) - CS(:,5));
after_disruption = CS;