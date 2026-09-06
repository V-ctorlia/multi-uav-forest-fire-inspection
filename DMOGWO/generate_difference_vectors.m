function [d_alpha, d_beta, d_delta] = generate_difference_vectors(Xi, X_alpha, X_beta, X_delta)
    % 生成差异向量d_alpha、d_beta、d_delta
    % 输入：Xi - 当前灰狼位置
    %       X_alpha, X_beta, X_delta - Alpha, Beta, Delta狼位置
    % 输出：d_alpha, d_beta, d_delta - 差异向量
    
    % 计算汉明距离
    hd_alpha = hamming_distance(Xi, X_alpha);
    hd_beta = hamming_distance(Xi, X_beta);
    hd_delta = hamming_distance(Xi, X_delta);
    
    % 随机生成差异向量（差异数量）
    d_alpha = randi([1, hd_alpha]);
    d_beta = randi([1, hd_beta]);
    d_delta = randi([1, hd_delta]);
end

