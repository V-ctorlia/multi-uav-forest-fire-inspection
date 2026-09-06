function new = Symmetry(sequence,ntarget, numDrones)
    % 随机选择两个位置，定义反转范围
     m=sequence;
    sequence=m(1:ntarget);
    n = length(sequence);
    idx = sort(randperm(n, 2));  % 确保 idx1 < idx2
    idx1 = idx(1);
    idx2 = idx(2);
    
    % 提取并反转该区间的顺序
    reversed_segment = sequence(idx1:idx2);
    reversed_segment = reversed_segment(end:-1:1);
    
    % 将反转后的区间放回原位置
    new_sequence = sequence;
    new_sequence(idx1:idx2) = reversed_segment;

     m(1:ntarget)=new_sequence;
     new=adjustbreak(m,ntarget, numDrones);
end
