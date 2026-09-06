function distances = CalculateDistances(solution, target3d)
    ntarget = size(target3d, 1);
    breakpoint1 = solution(ntarget + 1);
    breakpoint2 = solution(ntarget + 2);
    
    % 根据断点划分任务点序列为 3 段路径
    path1 = solution(1:breakpoint1);
    path2 = solution(breakpoint1 + 1:breakpoint2);
    path3 = solution(breakpoint2 + 1:ntarget);
    
    
    % 初始化存储每架无人机的距离列表
    distances = cell(1, 3);
    
    % 计算第一架无人机的相邻点欧氏距离
    distances{1} = CalculateEuclideanDistances(path1, target3d);
    
    % 计算第二架无人机的相邻点欧氏距离
    distances{2} = CalculateEuclideanDistances(path2, target3d);
    
    % 计算第三架无人机的相邻点欧氏距离
    distances{3} = CalculateEuclideanDistances(path3, target3d);
end

function distList = CalculateEuclideanDistances(path, target3d)
    % 初始化距离列表
    distList = zeros(1, length(path) - 1);
    
    % 计算相邻点之间的欧氏距离
    for i = 1:length(path) - 1
        pointA = target3d(path(i), :);
        pointB = target3d(path(i + 1), :);
        distList(i) = norm(pointA - pointB);
    end
end
