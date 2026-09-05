clc;
clear all;

    % 参数设置
    popSize = 50;        % 种群大小
    numGenerations = 500; % 最大迭代次数
    numDrones = 3;        % 无人机数量
   
    % 加载地形数据和巡检点坐标

    load('terrain.mat');  % 100x100 地形高度矩阵，变量为 terrain
    load('Target-20.mat');   % 20个巡检点坐标，变量为 target
    numPoints = size(target, 1); % 巡检点数量


   % 网格坐标 X 和 Y (x 范围 [0,100], y 范围 [0,100])

   [X, Y] = meshgrid(linspace(0, 100, 100), linspace(0, 100, 100));



   % 无人机起点和终点

   startPoint = [50, 50];  % 起点和终点为 [50, 50]



   % 运行 NSGA-II 算法 (这里假设结果为解集 population) 


   disp('Running NSGA-II optimization...');
   pop=nsga2(popSize, numGenerations, numPoints, numDrones, target, startPoint);
      %%
close all
    Plot2DContourView(X, Y, terrain, target, startPoint,pop,numDrones);


