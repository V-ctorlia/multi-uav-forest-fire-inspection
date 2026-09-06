function Plot2DContourView(X, Y, Z, inspectionPoints, startPoint,pop,numDrones)
    figure;
    contour(X, Y, Z, 20); % 绘制等高线图，20个等高线
    hold on;
    colors = {'b', 'g', 'm'};  % 为每个无人机分配不同颜色
    % 标记巡检点
    plot(inspectionPoints(:, 1), inspectionPoints(:, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    % 为每个任务点标注序号
for i = 1:size(inspectionPoints, 1)
    % 在每个点的旁边显示序号
    text(inspectionPoints(i,1) + 2, inspectionPoints(i,2)+2, num2str(i), 'FontSize', 10, 'Color', 'k');
end
    
    % 标记无人机起点和终点
    plot(startPoint(1), startPoint(2), 'bo', 'MarkerSize', 12, 'LineWidth', 2); % 绿色表示起点和终点
     
 load('matlab.mat');
    % solution=pop(5).Position;



 dronePaths = SplitSolutionByDrones(solution, numDrones);


for i = 1:numDrones
    path = dronePaths{i};
      % 无人机路径，添加起点和终点
        fullPath = [startPoint; inspectionPoints(path, :); startPoint];

    plot(fullPath(:, 1), fullPath(:, 2), [colors{i}, '-'], 'LineWidth', 2);  % 无人机二维路径
end



title('二维俯视图及优化后的无人机任务路径');
xlabel('X 坐标');
ylabel('Y 坐标');
grid on;



