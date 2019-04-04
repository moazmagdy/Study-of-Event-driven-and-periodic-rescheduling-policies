function mutationChildren = mutation_inversion(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,mutationRate)
mutationChildren = zeros(length(parents),GenomeLength);
rng('shuffle')
for i = 1:length(parents)
    parent = thisPopulation(parents(i),:);
    
    %Mutating The Sequence
    child = zeros(size(parent));
    pos1 = 0;
    pos2 = 0;
    % Choosing two (nonequal) mutation points 
    while pos1 == pos2
        pos1 = ceil(rand*(size(child,2)-1));
        pos2 = ceil(rand*(size(child,2)-1));
    end
    % Deal with the case if the interval wraps around the ends
    if pos1>pos2
        parentrepeat = [parent parent];
        pos3 = pos2 + size(parent,2);
        child(1,1:pos1-1) = parent(1,1:pos1-1);
        for yy = 0:(pos3-pos1)
            child(1,pos1+yy) = parentrepeat(1,pos3-yy);
        end
        child(1,1:pos2) = child(1,(size(parent,2)+1):pos3);
        child((size(parent,2)+1):pos3) = [];
    else % Deal with the normal case
        child(1,1:pos1-1) = parent(1,1:pos1-1);
        child(1,pos2+1:size(parent,2)) = parent(1,pos2+1:size(parent,2));
        for yy = 0:(pos2-pos1)
            child(1,pos1+yy) = parent(1,pos2-yy);
        end
    end
    mutationChildren(i,:) = child;

end