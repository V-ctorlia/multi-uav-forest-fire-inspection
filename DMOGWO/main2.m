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



   %% 运行 NSGA-II 算法 (这里假设结果为解集 population) 


   disp('Running NSGA-II optimization...');
   pop=nsga2(popSize, numGenerations, numPoints, numDrones, target, startPoint, task);


   %%




   
  figure;
  Z=terrain;
    contour(X, Y, Z, 20); % 绘制等高线图，20个等高线
    hold on;
    colors = {'b', 'g', 'm'};  % 为每个无人机分配不同颜色
    % 绘制每一级的矩形边框
for i = 1:levels
    lower_left = center - i * step_size;
    width = 2 * i * step_size;
    rectangle('Position', [lower_left(1), lower_left(2), width, width], ...
              'EdgeColor', 'b', 'LineStyle', '--','LineWidth', 1);
      
    % 标注等级数（显示在矩形框内的右下角，稍微向内偏移）
    text(lower_left(1) + width - step_size * 0.1, lower_left(2) + step_size * 0.1, ...
         sprintf('Level %d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', 'b');
   
end
    % 标记巡检点
    plot(target(:, 1), target(:, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    % 为每个任务点标注序号
for i = 1:size(target, 1)
    % 在每个点的旁边显示序号
    text(target(i,1) + 2, target(i,2)+2, num2str(i), 'FontSize', 10, 'Color', 'k');
end
    
    % 标记无人机起点和终点
    plot(startPoint(1), startPoint(2), 'bo', 'MarkerSize', 12, 'LineWidth', 2); % 绿色表示起点和终点

xlabel('X 坐标');
ylabel('Y 坐标');
grid on;



    %%
     
% load('matlab.mat');
     solution=pop(5).Position;



 dronePaths = SplitSolutionByDrones(solution, numDrones);


for i = 1:numDrones
    path = dronePaths{i};
      % 无人机路径，添加起点和终点
        fullPath = [startPoint; target(path, :); startPoint];

    plot(fullPath(:, 1), fullPath(:, 2), [colors{i}, '-'], 'LineWidth', 2);  % 无人机二维路径
end



title('二维俯视图及优化后的无人机任务路径');
xlabel('X 坐标');
ylabel('Y 坐标');
grid on;

