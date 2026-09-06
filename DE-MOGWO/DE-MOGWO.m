

clear all
clc

drawing_flag = 1;
load Rugged2;
nVar=model.n.*3;

fobj=@(x) evaluate(x,model);
% Lower bound and upper bound
lb=repmat([model.xmin,model.ymin,model.zmin],1,model.n);
ub=repmat([model.xmax,model.ymax,model.zmax],1,model.n);

VarSize=[1 nVar];

GreyWolves_num=50;
MaxIt=1000;  % Maximum Number of Iterations
Archive_size=100;   % Repository Size

alpha=0.1;  % Grid Inflation Parameter
nGrid=10;   % Number of Grids per each Dimension
beta=4; %=4;    % Leader Selection Pressure Parameter
gamma=2;    % Extra (to be deleted) Repository Member Selection Pressure

% Initialization

GreyWolves=CreateEmptyParticle(GreyWolves_num);


for i=1:GreyWolves_num
    GreyWolves(i).Velocity=0;
   
    GreyWolves(i)=initialize( GreyWolves(i),model);
    GreyWolves(i).Cost=fobj(GreyWolves(i).Position);
    GreyWolves(i).Best.Position=GreyWolves(i).Position;
    GreyWolves(i).Best.Cost=GreyWolves(i).Cost;
end

GreyWolves=DetermineDomination(GreyWolves);

Archive=GetNonDominatedParticles(GreyWolves);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOGWO main loop

for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    for i=1:GreyWolves_num
        
        clear rep2
        clear rep3
        
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
            Beta=SelectLeader(rep2,beta);
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
            Alpha=SelectLeader(rep3,beta);
        end
        
        % Eq.(3.4) in the paper
        c=2.*rand(1, nVar);
        % Eq.(3.1) in the paper
        D=abs(c.*Delta.Position-GreyWolves(i).Position);
        % Eq.(3.3) in the paper
        A=2.*a.*rand(1, nVar)-a;
        % Eq.(3.8) in the paper
        X1=Delta.Position-A.*abs(D);
        
        
        % Eq.(3.4) in the paper
        c=2.*rand(1, nVar);
        % Eq.(3.1) in the paper
        D=abs(c.*Beta.Position-GreyWolves(i).Position);
        % Eq.(3.3) in the paper
        A=2.*a.*rand()-a;
        % Eq.(3.9) in the paper
        X2=Beta.Position-A.*abs(D);
        
        
        % Eq.(3.4) in the paper
        c=2.*rand(1, nVar);
        % Eq.(3.1) in the paper
        D=abs(c.*Alpha.Position-GreyWolves(i).Position);
        % Eq.(3.3) in the paper
        A=2.*a.*rand()-a;
        % Eq.(3.10) in the paper
        X3=Alpha.Position-A.*abs(D);
        
        % Eq.(3.11) in the paper
        GreyWolves(i).Position=(X1+X2+X3)./3;
        
        % Boundary checking
         GreyWolves(i).Position=min(max(GreyWolves(i).Position,lb),ub);
         GreyWolves(i)= adjust_HIGHT(GreyWolves(i),model);
 
        
        GreyWolves(i).Cost=fobj(GreyWolves(i).Position);
    end
    
    GreyWolves=DetermineDomination(GreyWolves);
    non_dominated_wolves=GetNonDominatedParticles(GreyWolves);
    
    Archive=[Archive
        non_dominated_wolves];
    
    Archive=DetermineDomination(Archive);
    Archive=GetNonDominatedParticles(Archive);
    
    for i=1:numel(Archive)
        [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
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




%% 绘图
% 1. 生成基础网格
n = 100;  % 网格大小 (100x100)
[x, y] = meshgrid(linspace(0, 100, n), linspace(0, 100, n));

% 2. 加载地形数据 (假设 terrain.mat 包含 mesh_points)
load('terrain.mat');  % 加载地形数据, mesh_points 是 [100x100] 高度矩阵

% 3. 起点和终点
start_point = [5, 90, 2];
end_point = [90, 5, 3];

% 4. 假设算法已经计算好路径点，假设 path_points 是 [Nx3] 的矩阵 (x, y, z)
path_points = Archive(floor(numel(Archive)/2)-2).Position;  % 示例路径点
path_points = reshape(path_points, 3, [])';
path_points=[start_point;path_points;end_point];
% 5. 三维图绘制地形和路径
figure;
mesh(x, y, terrain);
colormap("summer"); 
hold on;
plot3(path_points(:, 1), path_points(:, 2), path_points(:, 3), 'r-', 'LineWidth', 2);  % 绘制路径线段
scatter3(start_point(1), start_point(2), start_point(3), 'go', 'filled');  % 绘制起点
scatter3(end_point(1), end_point(2), end_point(3), 'bo', 'filled');  % 绘制终点
hold off;

% 6. 图像设置
xlabel('X');
ylabel('Y');
zlabel('Z (Height)');
title('3D Terrain with Path');
grid on;
view(3);  % 三维视角


% 9. 绘制二维俯视图
figure;
contour(x, y, terrain, 20);  % 绘制地形等高线
hold on;
plot(path_points(:, 1), path_points(:, 2), 'r-', 'LineWidth', 2);  % 绘制路径线段 (只绘制XY)
scatter(start_point(1), start_point(2), 'go', 'filled');  % 绘制起点 (XY)
scatter(end_point(1), end_point(2), 'bo', 'filled');  % 绘制终点 (XY)
hold off;

% 图像设置
xlabel('X');
ylabel('Y');
title('Top View of Terrain with Path');
grid on;
view(2);  % 俯视视角
