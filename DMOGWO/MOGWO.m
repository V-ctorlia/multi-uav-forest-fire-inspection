
function [ Archive,Archive_costs]=MOGWO(popSize, numGenerations, ~, numDrones, inspectionPoints, startPoint,task)

ntarget=size(inspectionPoints,1);
nVar=ntarget+numDrones-1; 
GreyWolves_num=popSize;
nPop = popSize; 
MaxIt=numGenerations;  % Maximum Number of Iterations
Archive_size=50;   % Repository Size
drawing_flag=1;

alpha=0.1;  % Grid Inflation Parameter
nGrid=10;   % Number of Grids per each Dimension
beta=4; %=4;    % Leader Selection Pressure Parameter
gamma=2;    % Extra (to be deleted) Repository Member Selection Pressure

% Initialization

GreyWolves=CreateEmptyParticle(GreyWolves_num);
popi= initialize_population(ntarget, nPop, startPoint,  inspectionPoints);

for i=1:GreyWolves_num
    GreyWolves(i).Velocity=0;
    GreyWolves(i).Position=popi(i,:);
  
    GreyWolves(i).Cost=EvaluatePopulation( GreyWolves(i).Position, inspectionPoints, startPoint, numDrones);
    GreyWolves(i).Best.Position=GreyWolves(i).Position;
    GreyWolves(i).Best.Cost=GreyWolves(i).Cost;
end

GreyWolves=DetermineDomination(GreyWolves);

Archive=GetNonDominatedParticles(GreyWolves);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOGWO main loop

for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    rc=0.9-(0.9-0.1)*(it/MaxIt)^2;%1-0线性递减，用于区分局部和全局策略
    for i=1:GreyWolves_num
        
                % 移除 clear 语句，或者用初始化替换它们
        % clear rep2
        % clear rep3
        rep2 = Archive([]);  % 创建一个与 Archive 相同类型的空结构体
        rep3 = Archive([]);

        
        % Choose the alpha, beta, and delta grey wolves
        Delta=SelectLeader(Archive,beta);
        Beta=SelectLeader(Archive,beta);
        Alpha=SelectLeader(Archive,beta);
        
        % If there are less than three solutions in the least crowded
        % hypercube, the second least crowded hypercube is also found
        % to choose other leaders from.
        if size(Archive,1)>1
            counter=0;
            for newi=1:size(Archive,1)
                if sum(Delta.Position~=Archive(newi).Position)~=0
                    counter=counter+1;
                    rep2(counter,1)=Archive(newi);
                end
            end
             if ~isempty(rep2)
                Beta=SelectLeader(rep2,beta);
            end
            
        end
        
        % This scenario is the same if the second least crowded hypercube
        % has one solution, so the delta leader should be chosen from the
        % third least crowded hypercube.
        if size(Archive,1)>2
            counter=0;
            for newi=1:size(rep2,1)
                if sum(Beta.Position~=rep2(newi).Position)~=0
                    counter=counter+1;
                    rep3(counter,1)=rep2(newi);
                end
            end
            if exist('rep3', 'var') && ~isempty(rep3)
                Alpha = SelectLeader(rep3, beta);
            else
                Alpha = SelectLeader(rep2, beta); % 从 rep2 中选择
            end
        end
    
        % 初始化新的位置
        newPosition1 = GreyWolves(i).Position;
       


        cp1=rand;%全局和局部的操作符
        cp2=rand;%选择领导者
        if cp1<rc   %局部操作
            r1=rand;
            if r1<=0.4%Swap
                newPosition1 = Swap(newPosition1,ntarget, numDrones);
            elseif r1>0.4 && r1<=0.7
                newPosition1 = Shift(newPosition1,ntarget, numDrones);
            elseif r1>0.7
                newPosition1 = Symmetry(newPosition1,ntarget, numDrones);
            end
        else %全局操作
            
            if cp2<0.4
               
                newPosition1 = Cross(newPosition1,Alpha.Position,ntarget);
            elseif cp2>0.4 && cp2<=0.75
                newPosition1 = Cross(newPosition1,Beta.Position,ntarget);
            elseif cp2>0.75
                newPosition1 = Cross(newPosition1,Delta.Position,ntarget);
            end

        end

        %调整解
        newPosition1=adjustsolution(newPosition1, inspectionPoints, startPoint, numDrones);

        % %贪婪选取,使用双标准判断解的质量
        % newPosition1=greedyselct(newPosition1,GreyWolves(i).Position);











        % %判断非支配排序，找到最好的解更新
        %     X1.Position =newPosition1;
        %      X2.Position =newPosition2;
        %       X3.Position =newPosition3;
        %       X=[X1;X2;X3];
        %       X=DetermineDomination(X);
        %       ArchiveX=GetNonDominatedParticles(X);

        % % Eq.(3.11) in the paper
        % if size(ArchiveX,1)>1
        %     GreyWolves(i).Position=ArchiveX(1).Position;
        % else
        %     GreyWolves(i).Position=ArchiveX.Position;
        % end



        GreyWolves(i).Position=newPosition1;
        GreyWolves(i).Cost=EvaluatePopulation( GreyWolves(i).Position, inspectionPoints, startPoint, numDrones);
        
       
    end
    
    GreyWolves=DetermineDomination(GreyWolves);
    non_dominated_wolves=GetNonDominatedParticles(GreyWolves);
    
    Archive=[Archive
        non_dominated_wolves];
    
    Archive=DetermineDomination(Archive);
    Archive=GetNonDominatedParticles(Archive);
    
    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end
    
    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);
        
        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);
        
    end
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results
    
    % Results
    
    costs=GetCosts(GreyWolves);
    Archive_costs=GetCosts(Archive);
    
    if drawing_flag==1
      
        plot(Archive_costs(1,:),Archive_costs(2,:),'rd');
        legend('Non-dominated solutions');
        drawnow
    end
    
end


