function xoverKids = crossover_besthybrid_BM_MS(parents,options,GenomeLength,FitnessFcn,unused,thisPopulation)
global s;
rng('shuffle')
global limited;
global limited_2;
global limited_3;
start = limited;
initial_fit = limited_2;
a = limited_3;
nKids = length(parents)/2;
xoverKids = zeros(nKids,GenomeLength);
index = 1;

for pp=1:nKids
    % get parents
    parent_1 = thisPopulation(parents(index),:);
    index = index + 1;
    parent_2 = thisPopulation(parents(index),:);
    index = index + 1;
        % Precedence Preservative Crossover For The Sequence Part
    Both = [];
    parent1=parent_1;
    parent2=parent_2;
    % Selection Vector
    Select = ceil(2*rand(1,length(parent1)));
    Child = []; %% Preallocation for speed
    for ii = 1:length(Select)
        if Select(1,ii) == 1
            Child = [Child parent1(1,1)];
            parent2(parent2(1,:)==parent1(1,1)) = [];
            parent1(1) = [];
        elseif Select(1,ii) == 2
            Child = [Child parent2(1,1)];
            parent1(parent1(1,:)==parent2(1,1)) = [];
            parent2(1) = [];
        end
    end

    if a == 1
        x = tardiness(Child,start,initial_fit);
    elseif a == 2
        x = lateness(Child,start,initial_fit);
    elseif a ==0
        x = total_cost(Child,start,initial_fit);
    end
    Both = [Both;[x Child]];
    
    % Set Partition Crossover For The Sequence Part
    parent1=parent_1;
    parent2=parent_2;
    % divide sets
    No_of_jobs = length(parent1);
    Set1 = [];
    Set2 = [];
    % checking if any set is empty
    while isempty(Set1) == 1 || isempty(Set2) == 1
        ss = s;
        Set1 = [];
        Set2 = [];
        while sum(ss)>0
            ran = ceil(No_of_jobs*rand);
            if ss(ran)>0
                Set1 = [Set1 ss(ran)];
                ss(ran) = 0;
            end
            ran = ceil(No_of_jobs*rand);
            if ss(ran)>0
                Set2 = [Set2 ss(ran)];
                ss(ran) = 0;
            end
        end
    end
    % creating a new child
    Child=[];
    sss =1;
    for sss = 1:length(parent1)
        if ~isempty(find(Set1(1,:)==parent1(sss), 1));
            Child=[Child parent1(sss)];
        end
        if ~isempty(find(Set2(1,:)==parent2(sss), 1))
            Child = [Child parent2(sss)];
        end
    end
    % The Final Child With The Two Parts
    if a == 1
        y = tardiness(Child,start,initial_fit);
    elseif a == 2
        y = lateness(Child,start,initial_fit);
    elseif a ==0
        y = total_cost(Child,start,initial_fit);
    end
    Both = [Both;[y Child]];
    
    % Selecting the Best Child
    ppp =find(Both(:,1)==min(Both(:,1)),1);
    xoverKids(pp,1:size(Both,2)-1) = Both(ppp,2:end);
    
end
