function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
  warning(['Objective function not specified, ''' objFunc ''' used']);
  fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
  error('Argument FITFUNC must be a string');
end
if isempty(T)
  warning(['Budget not specified. 1000000 used']);
  T = '1000000';
end
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population 
%% Below starting your code

% Define ratio of crossover and mutation
ratioCrossover = 0.6;   % ratio of offsprings generated by crossover
ratioMutation = 0.1;

% Initialise a population
nbPop = 4; % required to be even
nbBits = 5;
nMin = 0;
nMax = 31;
pop = randi([nMin nMax], nbPop, 1);

% Evaluate the initial population
[bestFitInit, bestSolutionInit, fitnessThisRound] = evaluation(pop, fitFunc);
bestSoFarFit = bestFitInit;
bestSoFarSolution = bestSolutionInit;

fitness_pop = [fitness_pop bestSoFarFit];
fitness_gen = [fitness_gen bestSoFarFit];
solution_gen = [solution_gen bestSoFarSolution];
nbGen = nbGen + 1;
nbEval = nbEval + nbPop;

% Start the loop
while (nbEval<T)
    
    % Reproduction (selection, crossver)
    %% TODO
    offspring = [];
    totFit = sum(fitnessThisRound);
    nbIndividualsForCrossOver = nbPop * ratioCrossover;
    while nbIndividualsForCrossOver > 0
        [selectedParent1, selectedParent2] = selectAPair(pop, nbPop, totFit, fitnessThisRound);
        [offspring1, offspring2] = crossover(selectedParent1, selectedParent2, nbBits);
        offspring = [offspring offspring1 offspring2];
        nbIndividualsForCrossOver = nbIndividualsForCrossOver - 2; 
    end
    [rest, indices] = sort(fitnessThisRound, 1, 'descend');
    for i = 1 : (nbPop - numel(offspring))
        offspring = [offspring pop(i)];
    end
    
    % Mutation
    offspring = mutate(nbPop, ratioMutation, offspring, nbBits);
    
    % Evaluation
    [bestFitThisRound, bestSolutionThisRound, fitnessThisRound] = evaluation(offspring, fitFunc);
    fitness_pop = [fitness_pop bestFitThisRound];
    if bestFitThisRound > bestSoFarFit
        bestSoFarFit = bestFitThisRound;
        bestSoFarSolution = bestSolutionThisRound;
    end
    fitness_gen = [fitness_gen bestSoFarFit];
    solution_gen = [solution_gen bestSoFarSolution];
    nbGen = nbGen + 1;
    nbEval = nbEval + nbPop;
    pop = offspring;
end

% Display figures
disp(['bestSoFarFit = ' num2str(bestSoFarFit)])
disp(['bestSoFarSolution = ' num2str(bestSoFarSolution)])

figure,plot(1:nbGen,fitness_gen,'b') 
title('Fitness\_Gen')

figure,plot(1:nbGen,solution_gen,'b') 
title('Solution\_Gen')

figure,plot(1:nbGen,fitness_pop,'b') 
title('Fitness\_Pop')
end

function [bestFitThisRound, bestSolutionThisRound, fitnessThisRound]=evaluation( ...
    pop, ... % population
    fitFunc) % name of objective/fitness function
    % Do evaluation on the population and return
    % the best solution and its corresponding fitness
    eval(sprintf('objective=@%s;',fitFunc));
    fitnessThisRound = objective(pop);
    [bestFitThisRound, bestSolutionIdx] = max(fitnessThisRound);
    bestSolutionThisRound = pop(bestSolutionIdx);
end



function [selectedParent1, selectedParent2...
    ]=selectAPair( ...
    pop, ...    % population
    nbPop, ...  % number of individuals in a population
    totFit, ... % sum of fitness
    fitnessThisRound)   % fitness array
    % select a pair of individuals
    selectedIndices = zeros(2, 1);
    % select two distinguish individuals
    while true
        randNum = randi([1 totFit], 2, 1);
        for i = 1 : 2
            for j = 1 : nbPop
                if randNum(i) - fitnessThisRound(j) <= 0
                    selectedIndices(i) = j;
                    break;
                end
                randNum(i) = randNum(i) - fitnessThisRound(j);
            end
        end
        if selectedIndices(1) ~= selectedIndices(2) || nbPop <= 2
            break
        end 
    end
    idx1 = selectedIndices(1);
    idx2 = selectedIndices(2);
    selectedParent1 = pop(idx1);
    selectedParent2 = pop(idx2);
end

function [crossover1, crossover2 ...
    ]=crossover( ...
    individual1, ... % first individual
    individual2, ... % second individual
    nbBits)          % number of bits
% here the individuals are not represented in binary, 
% we directly do crossover and mutation with binary operations

% randomly choose two segmentation points `seg1` and `seg2`, 
% and do crossover on [`seg1`, `seg2`]
sig1 = randi([1 nbBits], 1);
sig2 = randi([sig1 nbBits], 1);
mask = (2 ^ (sig2 - sig1 + 1) - 1) * (2 ^ (sig1 - 1));
[crossover1, crossover2] = deal(bitand(individual1, bitcmp(mask, "uint8")) + bitand(individual2, mask), bitand(individual2, bitcmp(mask, "uint8")) + bitand(individual1, mask));
end

function offspring = mutate(...
    nbPop, ...          % number of population
    ratioMutation, ...  % ratio of mutation
    offspring, ...      % offspring for mutation
    nbBits)             % number of bits
    % Do mutation on offspring generated by crossover
    for i = 1:nbPop
        if rand(1) < ratioMutation
            individual = offspring(i);
            low = randi([1 nbBits], 1);
            high = randi([low nbBits], 1);
            mask = (2 ^ (high - low + 1) - 1) * (2 ^ (low - 1));
            % bitwise not on range [low, high]
            offspring(i) = bitand(individual, bitcmp(mask, "uint8")) + bitand(bitcmp(individual, "uint8"), mask);
        end
    end
end

