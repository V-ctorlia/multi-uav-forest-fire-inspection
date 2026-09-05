%openfig('untitled.fig')
clear all
close all
clc
global xy
global position1
start_point = [52, 44, 0.1];
end_point = [52, 44, 0.1];
load Rugged2;
load('terrain.mat');  % 加载地形数据, mesh_points 是 [100x100] 高度矩阵
load('solution-21.mat');
% terrain=terrain/2;
model.start=start_point;
model.end=start_point;
load('target3d_21.mat');
numPoints = size(target3d, 1); % 巡检点数量
inspectionPoints=target3d;
numDrones=3;
 colors = {'#A2142F', [0.67,0.40,0.92], [0.4660 0.6740 0.1880]};
dronePaths = SplitSolutionByDrones(solution, numDrones);
savepath= cell(1, numDrones);
 figure(1);
  %三维图绘制地形和路径
            % 1. 生成基础网格
            n = 100;  % 网格大小 (100x100)
            [x, y] = meshgrid(linspace(0, 100, n), linspace(0, 100, n));
        
            mesh(x, y, terrain);
            colormap("summer");
             hold on;
             plot3(start_point(1), start_point(2), start_point(3), 'k^', 'MarkerSize', 12, 'LineWidth', 2); % 绿色表示起点和终点
              hold on;
             plot3(inspectionPoints(:, 1), inspectionPoints(:, 2),inspectionPoints(:, 3), 'Color',"#A2142F",'Marker','o', 'LineStyle',"none", 'MarkerSize', 6, 'LineWidth', 2);
            hold on;
            for i = 1:size(target3d, 1)
    % 在每个点的旁边显示序号
    text(target3d(i,1) + 2, target3d(i,2)+2, target3d(i,3)+1,num2str(i), 'FontSize', 10, 'Color', 'k');
end
            xlabel('X/10^2m');
            ylabel('Y/10^2m');
            zlabel('Z/m');
figure(2)
contour(x, y, terrain, 20);  % 绘制地形等高线
hold on;
scatter(start_point(1), start_point(2), 'go', 'filled');  % 绘制起点 (XY)
scatter(end_point(1), end_point(2), 'bo', 'filled');  % 绘制终点 (XY)
%%
for i = 1:numDrones
    path = dronePaths{i};
      % 无人机路径，添加起点和终点
      fullPath = [start_point; inspectionPoints(path, :); end_point];
        for j = 1: size(fullPath,1)-1
            %%
            model.start=fullPath(j,:);
            model.end = fullPath(j+1,:);
            % [~,T]=testcross(fullPath(j,:), fullPath(j+1,:), terrain);
            % if T==0
            %     figure(1);
            %     plot3([fullPath(j,1), fullPath(j+1,1)], [fullPath(j,2), fullPath(j+1,2)], [fullPath(j,3), fullPath(j+1,3)], [colors{i}, '-'], 'LineWidth', 2); % 绘制连线并标记两点
            %      figure(2);
            % plot([fullPath(j,1), fullPath(j+1,1)], [fullPath(j,2), fullPath(j+1,2)], [colors{i}, '-'], 'LineWidth', 2);  % 绘制路径线段 (只绘制XY)
            % else

                [ Archive,Archive_costs] = MGWO(model);
                % 假设算法已经计算好路径点，假设 path_points 是 [Nx3] 的矩阵 (x, y, z)
                [~,idx]=min(Archive_costs(1,:));
                path_points = Archive(idx).Position;  % 示例路径点2

                %%
                  path_points = Archive(31).Position;  % 示例路径点2
                trans=reshape(path_points, 2, [])';
                if xy==1
                    xx=[trans(:,1) position1(2:model.n+1,2)  trans(:,2)];
                else
                    xx=[position1(2:model.n+1,1) trans(:,1)  trans(:,2)];
                end
            path_points = xx;
            path_points=[fullPath(j,:);path_points;fullPath(j+1,:)];
            

            % 三维图绘制地形和路径
            figure(1);
            plot3(path_points(:, 1), path_points(:, 2), path_points(:, 3), 'Color', colors{i}, 'LineWidth', 2);  % 绘制路径线段
            drawnow;
            figure(2);
            plot(path_points(:, 1), path_points(:, 2),'Color', colors{i}, 'LineWidth', 2);  % 绘制路径线段 (只绘制XY)
            drawnow;  % 实时更新图像
            % end
            


       

        end
    

   
end
%% 绘图

% 6. 图像设置
figure(1);
xlabel('X');
ylabel('Y');
zlabel('Z (Height)');
title('3D Terrain with Path');
grid on;
view(3);  % 三维视角


% 9. 绘制二维俯视图
figure(2);
plot(start_point(1), start_point(2), 'k^', 'MarkerSize', 12, 'LineWidth', 2); % 绿色表示起点和终点
hold on;
plot(inspectionPoints(:, 1), inspectionPoints(:, 2), 'Color',"#A2142F",'Marker','o', 'LineStyle',"none", 'MarkerSize', 6, 'LineWidth', 2);
hold on;
% 图像设置
xlabel('X');
ylabel('Y');
title('Top View of Terrain with Path');
grid on;
view(2);  % 俯视视角
