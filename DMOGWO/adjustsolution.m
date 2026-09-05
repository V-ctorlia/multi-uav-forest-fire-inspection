function newParticle = adjustsolution(particle, inspectionPoints, startPoint, numDrones)
    ntarget = size(inspectionPoints,1); % 任务点数量
    breakpoints = particle(ntarget+1:end);
    sequence = particle(1:ntarget);

    % 根据断点划分路径段
    path1 = sequence(1:breakpoints(1));
    path2 = sequence(breakpoints(1)+1:breakpoints(2));
    path3 = sequence(breakpoints(2)+1:end);

    % 构建距离矩阵
    distMatrix = zeros(ntarget, ntarget);
    for i = 1:ntarget
        for j = 1:ntarget
            distMatrix(i, j) = norm(inspectionPoints(i, :) - inspectionPoints(j, :));
        end
    end

    % 找到路径段中距离最大的任务点 A
    [~, taskA, segmentIdx] = FindMaxDistanceTask({path1, path2, path3}, distMatrix);

    % 从原路径段中移除任务点 A
    if segmentIdx == 1
        path1(path1 == taskA) = [];
    elseif segmentIdx == 2
        path2(path2 == taskA) = [];
    else
        path3(path3 == taskA) = [];
    end

    % 找到任务点 A 最近的任务点 B
    allTasks = [path1, path2, path3];
    pathWithoutA = allTasks(allTasks ~= taskA);
    [~, idxB] = min(distMatrix(taskA, pathWithoutA));
    taskB = pathWithoutA(idxB);

    % 获取任务点 B 在路径中的位置
    idxB = find(allTasks == taskB);

    if ismember(taskB, path1)
        idxBInSegment = find(path1 == taskB);
        % 尝试将任务点 A 插入到任务点 B 的前面
        pathBefore = [path1(1:idxBInSegment-1), taskA, path1(idxBInSegment:end)];
        % 尝试将任务点 A 插入到任务点 B 的后面
        pathAfter = [path1(1:idxBInSegment), taskA, path1(idxBInSegment+1:end)];
        seq1=[pathBefore, path2, path3];
        seq2=[pathAfter, path2, path3];
        % 更新断点位置
        break1 = length(path1);
        break2 = break1 + length(path2);
        newBreakpoints = [break1, break2];
        sequence1=[seq1, newBreakpoints];
        sequence2=[seq2, newBreakpoints];


    elseif ismember(taskB, path2)
        idxBInSegment = find(path2 == taskB);
        % 尝试将任务点 A 插入到任务点 B 的前面
        pathBefore = [path2(1:idxBInSegment-1), taskA, path2(idxBInSegment:end)];
        % 尝试将任务点 A 插入到任务点 B 的后面
        pathAfter = [path2(1:idxBInSegment), taskA, path2(idxBInSegment+1:end)];
        seq1=[path1, pathBefore, path3];
        seq2=[path1, pathAfter, path3];
        % 更新断点位置
        break1 = length(path1);
        break2 = break1 + length(path2);
        newBreakpoints = [break1, break2];
        sequence1=[seq1, newBreakpoints];
        sequence2=[seq2, newBreakpoints];
    else
        idxBInSegment = find(path3 == taskB);
        % 尝试将任务点 A 插入到任务点 B 的前面
        pathBefore = [path3(1:idxBInSegment-1), taskA, path3(idxBInSegment:end)];
        % 尝试将任务点 A 插入到任务点 B 的后面
        pathAfter = [path3(1:idxBInSegment), taskA, path3(idxBInSegment+1:end)];
        seq1=[path1, path2, pathBefore];
        seq2=[path1, path2, pathAfter];
        % 更新断点位置
        break1 = length(path1);
        break2 = break1 + length(path2);
        newBreakpoints = [break1, break2];
        sequence1=[seq1, newBreakpoints];
        sequence2=[seq2, newBreakpoints];
    end
    
    % 计算目标函数值
    cost1 = EvaluatePopulation(sequence1, inspectionPoints, startPoint, numDrones);
    cost2 = EvaluatePopulation(sequence2, inspectionPoints, startPoint, numDrones);
    cost1=cost1(1)+cost1(2);
    cost2=cost2(1)+cost2(2);


   % 选择代价较小的作为新个体
    if cost1 < cost2
        newParticle = sequence1;
    else
         newParticle = sequence2;
    end

end









function [maxDist, taskA, segmentIdx] = FindMaxDistanceTask(paths, distMatrix)
    maxDist = 0;
    taskA = 0;
    segmentIdx = 0;

    % 遍历 3 段路径，找到最大距离的任务点
    for i = 1:length(paths)
        path = paths{i};
        for j = 1:length(path)-1
            dist = distMatrix(path(j), path(j+1));
            if dist > maxDist
                maxDist = dist;
                taskA = path(j);
                segmentIdx = i;
            end
        end
    end
end
