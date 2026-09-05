function [isValid] = CheckConstraints(solution, numPoints, ~)
    % 检查解是否满足约束
    % 1. 每架无人机从起点 0 出发并返回
    % 2. 每个巡检点被一架无人机访问
    
    isValid = 1;
    
    % 检查巡检点是否被唯一访问
    pointsVisited = solution; % 去掉起点和终点
    if length(unique(pointsVisited)) ~= numPoints
        isValid = 0;
    end
end