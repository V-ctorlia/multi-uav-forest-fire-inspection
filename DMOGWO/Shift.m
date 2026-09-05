function new = Shift(sequence,ntarget, numDrones)
    % 随机选择两个位置，定义要提取的路径段范围
    m=sequence;
    sequence=m(1:ntarget);
    n = length(sequence);
    idx = sort(randperm(n, 2));  % 确保 idx1 < idx2
    idx1 = idx(1);
    idx2 = idx(2);
    
    % 提取路径段，并从原序列中移除
    pathSegment = sequence(idx1:idx2);
    remainingSequence = [sequence(1:idx1-1), sequence(idx2+1:end)];

    % 随机选择插入位置
    insertIdx = randi([1, length(remainingSequence) + 1]);

    % 构建新的序列，将路径段插入到指定位置
    new_sequence = [remainingSequence(1:insertIdx-1), pathSegment, remainingSequence(insertIdx:end)];
     m(1:ntarget)=new_sequence;
     new=adjustbreak(m,ntarget, numDrones);
   
end

