
function [cost1, cost2]=compare(popSize, numGenerations, ~, numDrones, inspectionPoints, startPoint,task)
%% Problem Definition

CostFunction = @(x) EvaluatePopulation(population, inspectionPoints, startPoint, numDrones);      % Cost Function

ntarget=size(inspectionPoints,1);

nVar = ntarget+numDrones-1;             % Number of Decision Variables


% Number of Objective Functions
nObj = 2;


%% NSGA-II Parameters

MaxIt = numGenerations;      % Maximum Number of Iterations

nPop = popSize;        % Population Size


%% Initialization

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.CrowdingDistance = [];
pop1 = repmat(empty_individual, nPop, 1);
pop2 = repmat(empty_individual, nPop, 1);
% popi= my_Create(nPop, nVar, ntarget);
popi= initialize_population1(ntarget, nPop, startPoint,  inspectionPoints,task);
popm= initialize_population_O(ntarget, nPop, startPoint,  inspectionPoints);

 % cost1=zeros(nPop,1)        
for i = 1:nPop
    
    pop1(i).Position = popi(i,:);
    pop2(i).Position = popm(i,:);


    
    pop1(i).Cost = EvaluatePopulation(pop1(i).Position, inspectionPoints, startPoint, numDrones);
    pop2(i).Cost = EvaluatePopulation(pop2(i).Position, inspectionPoints, startPoint, numDrones);

    
end
cost1=[pop1.Cost];
cost2=[pop2.Cost];


