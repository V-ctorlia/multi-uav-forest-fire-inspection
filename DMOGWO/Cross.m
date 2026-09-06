function newPosition = Cross(X, Alpha, ntarget)
    % Cross 函数：使用 Alpha 的断点对个体 X 进行路径划分，并进行交叉操作
    % 输入：
    %   - X: 当前个体的任务序列（1x(ntarget + 2))
    %   - Alpha: 领头狼的任务序列（1x(ntarget + 2))
    %   - ntarget: 任务点数量
    % 输出：
    %   - newPosition: 新生成的个体

    % 提取 Alpha 的断点位置
    breakpoint1 = Alpha(ntarget + 1);
    breakpoint2 = Alpha(ntarget + 2);

    % 使用 Alpha 的断点进行路径划分
    segment1_Alpha = Alpha(1:breakpoint1);
    segment2_Alpha = Alpha(breakpoint1 + 1:breakpoint2);
    segment3_Alpha = Alpha(breakpoint2 + 1:ntarget);

    segment1_X = X(1:breakpoint1);
    segment2_X = X(breakpoint1 + 1:breakpoint2);
    segment3_X = X(breakpoint2 + 1:ntarget);

    % 初始化新个体位置
    newPosition = zeros(1, ntarget + 2);

    % 随机交叉操作
    cp = rand;
    if cp > 0.6
        newPosition(1:breakpoint1) = segment1_X;
    else
        newPosition(1:breakpoint1) = segment1_Alpha;
    end

    cp = rand;
    if cp > 0.6
        newPosition(breakpoint1 + 1:breakpoint2) = segment2_X;
    else
        newPosition(breakpoint1 + 1:breakpoint2) = segment2_Alpha;
    end

    cp = rand;
    if cp > 0.6
        newPosition(breakpoint2 + 1:ntarget) = segment3_X;
    else
        newPosition(breakpoint2 + 1:ntarget) = segment3_Alpha;
    end

    % 更新新个体的断点位置为 Alpha 的断点位置
    newPosition(ntarget + 1) = breakpoint1;
    newPosition(ntarget + 2) = breakpoint2;

      % 修复重复和缺失的任务点
    newPosition = FixDuplicates(newPosition, ntarget);
end
function newSequence = FixDuplicates(sequence, ntarget)
    % FixDuplicates 函数：修复任务序列中的重复和缺失点
    % 输入：
    %   - sequence: 需要修复的任务序列（1x(ntarget + 2)）
    %   - ntarget: 任务点数量
    % 输出：
    %   - newSequence: 修复后的任务序列

    % 提取前 ntarget 个任务点序列
    taskSequence = sequence(1:ntarget);

    % 找到重复的任务点和缺失的任务点
    uniqueTasks = unique(taskSequence);
    missingTasks = setdiff(1:ntarget, uniqueTasks);
    [~, duplicateIndices] = unique(taskSequence, 'stable');
    duplicateIndices = setdiff(1:ntarget, duplicateIndices);

    % 修复重复的任务点
    for i = 1:length(duplicateIndices)
        if ~isempty(missingTasks)
            % 用缺失的任务点替换重复的任务点
            taskSequence(duplicateIndices(i)) = missingTasks(1);
            missingTasks(1) = []; % 移除已使用的缺失任务点
        end
    end

    % 更新修复后的序列
    newSequence = sequence;
    newSequence(1:ntarget) = taskSequence;
end
