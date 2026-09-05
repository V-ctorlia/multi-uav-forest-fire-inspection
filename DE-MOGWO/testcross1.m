function [c, ct] = testcross1(p1,terrain)
    % 输入:
    % p1, p2 - 路径两点的 3D 坐标 [x, y, z]
    % terrain - 地形高度的 2D 矩阵（与地形网格大小相同）
    
num_checkpoints=size(p1,1);
    ct=0;
    % 预定义系数
     cr = zeros(num_checkpoints-2,1);
    
    % 计算中间点之间的步长
     x_steps = p1(:,1);
    y_steps = p1(:,2);
    z_steps = p1(:,3);
    
    % 遍历中间点并与地形高度进行比较
    for i = 2:num_checkpoints-1
        % 获取地形高度矩阵中的 x, y 索引
        x_index = round(x_steps(i));
        y_index = round(y_steps(i));
        
       
        
        % 获取该点的地形高度
        terrain_height = terrain(y_index, x_index);
        
        % 检查该中间点的高度是否低于地形高度
        if z_steps(i) < terrain_height
            % 根据高度差调整系数
            cr(i) = abs(z_steps(i) - terrain_height);
            ct=1;
        end

    end
    c=max(cr);

end
