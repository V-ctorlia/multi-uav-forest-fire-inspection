function dronePaths = SplitSolutionByDrones(solution, numDrones)
    % solution: 1x22 维个体编码
    % numDrones: 无人机数量 (这里为3)
    ntarget=size(solution,2)-2;
    % 提取任务序列和断点
    taskSequence = solution(1: ntarget);  % 前20维任务序列
    breakpoints = sort(solution( ntarget+1:end));  % 后2维是断点，按升序排序

    % 根据断点将任务序列分配给每架无人机
    dronePaths = cell(1, numDrones);  % 创建一个元胞数组来存储每架无人机的任务
    
    % 第1架无人机的任务（从任务序列开始到第一个断点）
    dronePaths{1} = taskSequence(1:breakpoints(1));

    % 第2架无人机的任务（从第一个断点+1到第二个断点）
    dronePaths{2} = taskSequence(breakpoints(1)+1:breakpoints(2));

    % 第3架无人机的任务（从第二个断点+1到任务序列结束）
    dronePaths{3} = taskSequence(breakpoints(2)+1:end);
end
