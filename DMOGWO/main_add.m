clc;
clear all
close all
global target3d
global terrain
   startPoint = [52, 44];  % 起点和终点为 [50, 50]
   nvar=63;
    % 参数设置
    popSize = 50;        % 种群大小
    numGenerations = 500; % 最大迭代次数
    numDrones = 3;        % 无人机数量
    % 地图大小和中心点

map_size = 100;
center = [50,50];

% 分级数
levels = floor(nvar/(numDrones*2));

% 步长计算，假设每一级的步长相同
step_size = map_size / (2 * levels);

% 初始化每个等级的任务点计数
task_count_per_level = zeros(1, levels+1);
   
    % 加载地形数据和巡检点坐标

    load('terrain1.mat');  % 100x100 地形高度矩阵，变量为 terrai
    load('target3d_63.mat');
    load('solution-63.mat');
    load('add_10_63_3D.mat')
    target= target3d(:,1:2);
    add_10_38=add_10_63_3D(:,1:2);
add_10=add_10_63_3D;
    numPoints = size(target, 1); % 巡检点数量

    task(numPoints) = struct('position', [], 'rank', []);
 % global task

   % 网格坐标 X 和 Y (x 范围 [0,100], y 范围 [0,100])

   [X, Y] = meshgrid(linspace(0, 100, 100), linspace(0, 100, 100));





   %%




   
  figure;
  Z=terrain;
    contour(X, Y, Z, 20,'LineWidth', 0.5); % 绘制等高线图，20个等高线
    hold on;

    colors = {[0.6350 0.0780 0.1840], [0.4940 0.1840 0.5560], [0.4660 0.6740 0.1880]};  % 为每个无人机分配不同颜色

    % 标记巡检点
    plot(target(:, 1), target(:, 2), 'Color',"#A2142F",'Marker','o', 'LineStyle',"none", 'MarkerSize', 6, 'LineWidth', 2);
    hold on
    plot(add_10_38(:, 1), add_10_38(:, 2), 'rx','MarkerSize', 10, 'LineWidth', 1.5);
    alltask=[target;add_10_38];
    % 为每个任务点标注序号
for i = 1:size(alltask, 1)
    % 在每个点的旁边显示序号
    text(alltask(i,1) + 2, alltask(i,2)+2, num2str(i), 'FontSize', 8, 'Color', 'k');
end
    
    % 标记无人机起点和终点
    plot(startPoint(1), startPoint(2), 'k^', 'MarkerSize', 12, 'LineWidth', 2); % 绿色表示起点和终点

xlabel('X 坐标');
ylabel('Y 坐标');
grid on;



    %%  计算无人机巡检路径相邻两个路径点长度
    distances = CalculateDistances(solution, target3d);
    V=30;
    T=2;
    maxDistance=V*T;
    remainingPoints = RemoveVisitedPoints(solution,numDrones, distances, maxDistance);
    [updatedSolution, updatedCoords] = InsertAdditionalPoints(remainingPoints, add_10, target3d, solution);
   
%%
    dronePaths = SplitSolutionByDrones(updatedSolution, numDrones);

 colors = {'#A2142F', [0.67,0.40,0.92], [0.4660 0.6740 0.1880]};  % 为每个无人机分配不同颜色
for i = 1:numDrones
    path = dronePaths{i};
      % 无人机路径，添加起点和终点
        fullPath = [startPoint; alltask(path, :); startPoint];

    plot(fullPath(:, 1), fullPath(:, 2), 'Color',colors{i}, 'LineWidth', 2);  % 无人机二维路径
    hold on;

    % % 添加箭头
    % for j = 1:(size(fullPath, 1) - 1)
    %     % 计算箭头的起点和方向
    %     x_start = fullPath(j, 1);
    %     y_start = fullPath(j, 2);
    %     x_dir = fullPath(j + 1, 1) - fullPath(j, 1);
    %     y_dir = fullPath(j + 1, 2) - fullPath(j, 2);
    % 
    %     % 使用 quiver 添加箭头
    %     quiver(x_start, y_start, x_dir, y_dir, 0, 'MaxHeadSize', 0.2, 'Color', colors{i}, 'LineWidth', 1);
    % end
end




xlabel('X/10^2m');
ylabel('Y/10^2m');
grid on;
% %%
% Replanned-Scenario 1
% Initial-Scenario 1
