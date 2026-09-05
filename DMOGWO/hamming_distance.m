function hd = hamming_distance(X1, X2)
    % 计算X1和X2之间的汉明距离
    % 输入：X1, X2 - 两个位置向量（任务序列 + 分配断点）
    % 输出：hd - 汉明距离
    
    hd = sum(X1 ~= X2);  % 计算不同元素的数量
end

