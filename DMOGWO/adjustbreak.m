function new = adjustbreak(m, ntarget, numDrones)
    % 提取断点位置
    
    breakpoint1 = m(ntarget + 1);
    breakpoint2 = m(ntarget + 2);

    % 计算理想负载
    idealLoad = ceil(ntarget / numDrones);

    % 计算各段的任务负载
    load1 = breakpoint1;
    load2 = breakpoint2 - breakpoint1;
    load3 = ntarget - breakpoint2;

    % 检查并调整断点位置以平衡负载
    if load1 > idealLoad
        % 第一段负载过大，减小断点1的位置
        breakpoint1 = breakpoint1 - 1;
    elseif load2 > idealLoad
        % 第二段负载过大，减小断点2的位置
        breakpoint2 = breakpoint2 - 1;
    elseif load3 > idealLoad && breakpoint2 < ntarget
        % 第三段负载过大，增加断点2的位置
        breakpoint2 = breakpoint2 + 1;
    end

    % 更新后的个体
    new = m;
    new(ntarget + 1) = breakpoint1;
    new(ntarget + 2) = breakpoint2;
end

