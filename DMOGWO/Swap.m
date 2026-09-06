function new = Swap(sequence,ntarget, numDrones)
    % 随机选择两个不同的位置
    m=sequence;
    sequence=m(1:ntarget);
    n = length(sequence);
    idx = randperm(n, 2);
    idx1 = idx(1);
    idx2 = idx(2);
    
    % 交换两个位置的值
    new_sequence = sequence;
    temp = new_sequence(idx1);
    new_sequence(idx1) = new_sequence(idx2);
    new_sequence(idx2) = temp;

    m(1:ntarget)=new_sequence;
    new=adjustbreak(m,ntarget, numDrones);


end

