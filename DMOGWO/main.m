clc;
clear all
close all
global target3d
global terrain
   startPoint = [52, 44];  % 起点和终点为 [50, 50]
   nvar=38;
    % 参数设置
    popSize = 50;        % 种群大小
    numGenerations = 500; % 最大迭代次数
    numDrones = 3;        % 无人机数量
    % 地图大小和中心点

map_size = 100;
center = startPoint;

% 分级数
levels = floor(nvar/(numDrones*2));

% 步长计算，假设每一级的步长相同
step_size = map_size / (2 * levels);

% 初始化每个等级的任务点计数
task_count_per_level = zeros(1, levels+1);
   
    % 加载地形数据和巡检点坐标

    load('terrain1.mat');  % 100x100 地形高度矩阵，变量为 terrain

    load('target3d_38.mat');
    target= target3d(:,1:2);

    numPoints = size(target, 1); % 巡检点数量

    task(numPoints) = struct('position', [], 'rank', []);
   global task

   % 网格坐标 X 和 Y (x 范围 [0,100], y 范围 [0,100])

   [X, Y] = meshgrid(linspace(0, 100, 100), linspace(0, 100, 100));



   % 无人机起点和终点



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
      % 检测 rank 是否为空，如果为空，则设置为 levels + 1
    if isempty(task(i).rank)
        task(i).rank = levels + 1;
        task_count_per_level(levels + 1) = task_count_per_level(levels + 1) + 1; % 更新计数
    end
end


   % 输出每个等级的任务点数量
for i = 1:levels
    fprintf('Level %d contains %d task points.\n', i, task_count_per_level(i));
end



   %% 运行 DMOGWO 算法


  %%待录用后开放


   %%
  
  figure;
  Z=terrain;
   contour(X, Y, Z, 20); % 绘制等高线图，20个等高线
    hold on;

   colors = {'#A2142F', [0.67,0.40,0.92], [0.4660 0.6740 0.1880]};
    % colors = {'b', 'g', 'm'};  % 为每个无人机分配不同颜色



    % 标记巡检点
    plot(target(:, 1), target(:, 2), 'Color',"#A2142F",'Marker','o', 'LineStyle',"none", 'MarkerSize', 6, 'LineWidth', 2);
    % 为每个任务点标注序号
for i = 1:size(target, 1)
    % 在每个点的旁边显示序号
    text(target(i,1) + 2, target(i,2)+2, num2str(i), 'FontSize', 10, 'Color', 'k');
end
    
    % 标记无人机起点和终点
    plot(startPoint(1), startPoint(2), 'k^', 'MarkerSize', 12, 'LineWidth', 2); % 黑色三角表示起点和终点

   
   % load('solution-21.mat');
 solution=Archive(4).Position;



 dronePaths = SplitSolutionByDrones(solution, numDrones);
% 用于存储图例句柄
legendHandles = gobjects(1, numDrones); 
legendNames = cell(1, numDrones); % 图例名称

for i = 1:numDrones
    path = dronePaths{i};
      % 无人机路径，添加起点和终点
        fullPath = [startPoint; target(path, :); startPoint];

   h= plot(fullPath(:, 1), fullPath(:, 2),'Color', colors{i}, 'LineWidth', 2);  % 无人机二维路径
   legendHandles(i) = h; % 保存句柄
    legendNames{i} = sprintf('Drone %d', i); % 设置图例名称
end



title('二维俯视图及优化后的无人机任务路径');
xlabel('X/10^2m');
ylabel('Y/10^2m');
% grid on;

