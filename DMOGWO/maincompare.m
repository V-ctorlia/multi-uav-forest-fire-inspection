clc;
clear all
close all
global target3d
global terrain
    % 参数设置
    popSize = 50;        % 种群大小
    numGenerations = 500; % 最大迭代次数
    numDrones = 3;        % 无人机数量
    % 地图大小和中心点

map_size = 100;
center = [50, 50];

% 分级数
levels = 4;

% 步长计算，假设每一级的步长相同
step_size = map_size / (2 * levels);

% 初始化每个等级的任务点计数
task_count_per_level = zeros(1, levels);
   
    % 加载地形数据和巡检点坐标

    load('terrain1.mat');  % 100x100 地形高度矩阵，变量为 terrain
   % load('Target-20.mat');   % 20个巡检点坐标，变量为 target
    load('target3d_20.mat');
    target= target3d(:,1:2);

    numPoints = size(target, 1); % 巡检点数量

    task(numPoints) = struct('position', [], 'rank', []);


   % 网格坐标 X 和 Y (x 范围 [0,100], y 范围 [0,100])

   [X, Y] = meshgrid(linspace(0, 100, 100), linspace(0, 100, 100));



   % 无人机起点和终点

   startPoint = [52, 44];  % 起点和终点为 [50, 50]

   % 分级地图并将任务点信息存储在结构体中
for i = 1:numPoints
    task(i).position = target(i, :); % 存储任务点位置
    
    % 判断任务点属于哪个级别
    for level = 1:levels
        lower_left = center - level * step_size;
        upper_right = center + level * step_size;
        
        % 判断任务点是否在当前等级的矩形区域内
        if task(i).position(1) >= lower_left(1) && task(i).position(1) <= upper_right(1) && ...
           task(i).position(2) >= lower_left(2) && task(i).position(2) <= upper_right(2)
            task(i).rank = level; % 将等级存储在结构体中
             task_count_per_level(level) = task_count_per_level(level) + 1; % 更新任务计数
            break; % 任务点找到等级后，退出循环
        end
    end
end


   % 输出每个等级的任务点数量
for i = 1:levels
    fprintf('Level %d contains %d task points.\n', i, task_count_per_level(i));
end



   % 运行 NSGA-II 算法 (这里假设结果为解集 population) 

   [cost1, cost2]=compare(popSize, numGenerations, numPoints, numDrones, target, startPoint,task);

   %%
figure
 plot(cost1(1, :), cost1(2, :), 'r*', 'MarkerSize', 8);

 hold on 
plot(cost2(1, :), cost2(2, :), 'b*', 'MarkerSize', 8);
 hold on 
legend('improved','original');
hold off
 xlabel('1^{st} Objective');
 ylabel('2^{nd} Objective');
 title('Non-dominated Solutions (F_{1})');
 grid on;

