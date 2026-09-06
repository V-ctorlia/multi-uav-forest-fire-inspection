function remainingPoints = RemoveVisitedPoints(solution, numDrones,distances, maxDistance)
    % 输入：
    %   - inspectionPoints: cell 数组，每个 cell 包含一架无人机的巡检点序号
    %   - distances: cell 数组，每个 cell 包含对应无人机相邻巡检点的距离 (单位：km)
    %   - maxDistance: 无人机在 T 时间内的最大飞行距离 (单位：km)
    % 输出：
    %   - remainingPoints: cell 数组，每个 cell 包含未被飞过的巡检点序号
     inspectionPoints=cell(1,numDrones);
    ntarget = size(solution, 2)-numDrones+1;
    breakpoint1 = solution(ntarget + 1);
    breakpoint2 = solution(ntarget + 2);
    
    % 根据断点划分任务点序列为 3 段路径
    path1 = solution(1:breakpoint1);
    path2 = solution(breakpoint1 + 1:breakpoint2);
    path3 = solution(breakpoint2 + 1:ntarget);
    inspectionPoints{1}=path1;
    inspectionPoints{2}=path2;
    inspectionPoints{3}=path3;


    remainingPoints = cell(1, numDrones);

    for i = 1:numDrones
        % 初始化飞行距离
        currentDistance = 0;
        % 初始化剩余巡检点列表
        remainingIdx = 1;

        % 遍历相邻巡检点距离
        for j = 1:numel(distances{i})
            % 累加当前段距离
            currentDistance = currentDistance + distances{i}(j);

            % 如果累加距离超过最大飞行距离，停止计算
            if currentDistance > maxDistance
                break;
            end

            % 更新剩余巡检点序号
            remainingIdx = j + 1;
        end

        % 获取未飞过的巡检点序号
        remainingPoints{i} = inspectionPoints{i}(remainingIdx:end);
    end
end
