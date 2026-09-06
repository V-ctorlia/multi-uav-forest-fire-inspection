function [totalDistance, maxDroneDistance] = CalculateObjectives1(solution, inspectionPoints, startPoint, numDrones)
    % 计算个体的目标函数值
    % solution: 个体编码，表示巡检点的访问顺序和分配
    % inspectionPoints: 巡检点坐标矩阵
    % startPoint: 无人机的起点和终点坐标
    % numDrones: 无人机数量
global target3d
global terrain
global task
    % 将巡检点序列根据无人机数量拆分
   start_point = [52, 44, 0.1];
  end_point = [52, 44, 0.1];
    inspectionPoints=target3d;
    dronePaths = SplitSolutionByDrones(solution, numDrones);
    mtask=ceil(length(inspectionPoints)/numDrones);
     ctask=0;
    totalDistance = 0;
    droneDistances = zeros(numDrones, 1);
     [~,scores_pop] = selecttaskpoint(solution,task);
    
    for k = 1:numDrones
        path = dronePaths{k};
        ctask= (ctask+abs(mtask-length(path)));
        
        % 无人机路径，添加起点和终点
        fullPath = [start_point; inspectionPoints(path, :); end_point];
        
        % 计算无人机的巡检距离
        distance = 0;
        for i = 1:size(fullPath, 1) - 1
            dis= pdist2(fullPath(i, :), fullPath(i + 1, :));
            [c, ~] = testcross(fullPath(i, :), fullPath(i + 1, :), terrain);

            % distance = distance + c.*dis;
            distance = distance + dis;

        end
        
        droneDistances(k) = distance;
        totalDistance = totalDistance + distance;
    end
    % totalDistance=totalDistance+max(droneDistances);
    
     % maxDroneDistance = max(droneDistances);
    
    maxDroneDistance =scores_pop*(ctask+1);
end



