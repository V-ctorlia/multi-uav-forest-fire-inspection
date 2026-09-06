 function  object=evaluate(x,model)
 global xy
 global position1
 x=reshape(x, 2, [])';
 if xy==1
     xx=[x(:,1) position1(2:model.n+1,2)  x(:,2)];
 else
     xx=[position1(2:model.n+1,1) x(:,1)  x(:,2)];
 end
 
            
            x=[model.start; xx; model.end];
            % Input solution
            x_all = x(:,1);
            y_all = x(:,2);
            z_all = x(:,3);

            N = size(x_all,1); % Full path length
            %============================================
            % J1 - path length
            J1 = 0;

            for i = 1:N-1
                diff = [x_all(i+1) - x_all(i);y_all(i+1) - y_all(i);z_all(i+1) - z_all(i)];
                dd=norm(diff);
                p1=[x_all(i)  y_all(i)  z_all(i) ];
                p2=[x_all(i+1)  y_all(i+1)  z_all(i+1) ];
                [c(i), ~] = testcross(p1,p2, model.H);
                J1 = J1 + dd;


            end
            if max(c(i))~=1
                J1=max(c(i)).*J1.*10;

            end



            % % J2 - Height
            % J2 = sum(z_all).*3;



            % J2 - Height
            J2 = sum(z_all);
             mean_height = (z_all(1) + z_all(end)) / 2;
            z_middle = z_all(2:end-1);

            % 计算每个中间路径点与平均高度的差值
            height_diffs = abs(z_middle - mean_height);

            % 计算这些差值的总和
            total_height_diff = (sum(height_diffs*10));
            J2= J2+ total_height_diff;


            %==============================================

            % Evaluation Function
            object = [J1, J2];
 end


function [c, ct] = testcross2(p1,terrain)
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
    c=1+max(cr);

end




