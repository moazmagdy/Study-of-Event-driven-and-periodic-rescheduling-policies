function Population = Create_BM_MS(GenomeLength, FitnessFcn, options)
global s;
rng('shuffle')
Population = zeros(options.PopulationSize,length(s));
for i = 1:options.PopulationSize
    Population(i,:) = s(randperm(length(s)))';
end
