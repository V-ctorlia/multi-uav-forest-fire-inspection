function [updatedSolution, updatedCoords] = InsertAdditionalPoints(remainingPoints, add_10_38_3D, target3d, solution)
    % 输入：
    %   add_10_38_3D: 新增路径点的三维坐标（10x3）
    %   solution: 当前解（包含所有巡检点序号和断点）
    %   target3d: 原始任务点的三维坐标矩阵（ntarget x 3）
    % 输出：
    %   updatedSolution: 插入新增点后的解序列
    %   updatedCoords: 更新后的坐标矩阵，用于绘图

    ntarget = size(target3d, 1);
    breakpoints = solution(ntarget+1:end);
    sequence = solution(1:ntarget);

    % 根据断点划分路径段
    path1 = sequence(1:breakpoints(1));
    path2 = sequence(breakpoints(1)+1:breakpoints(2));
    path3 = sequence(breakpoints(2)+1:end);

     remainingPoints=[remainingPoints{1},remainingPoints{2},remainingPoints{3}];
    remainingPointsCoords = target3d(remainingPoints, :);

    solutionCoords = target3d(solution(1:ntarget), :);

    % 遍历每一个新增点
    for i = 1:size(add_10_38_3D, 1)
        newPoint = add_10_38_3D(i, :);

        % 计算新增点与所有剩余巡检点的距离
        distToRemainingPoints = vecnorm( remainingPointsCoords - newPoint, 2, 2);

        % 找到距离最近的巡检点 B
        [~, minIdx] = min(distToRemainingPoints);
        closestPointIdx = remainingPoints(minIdx);

        % 在第一个新增点插入后，更新 solution(1:ntarget+1)
        posB = find(solution(1:ntarget + i - 1) == closestPointIdx);

        % 取出 [B-1, B, B+1] 的坐标（处理边界情况）
        if posB == 1
            coordsBefore = solutionCoords([posB, posB+1], :);
        elseif posB == ntarget + i - 1
            coordsBefore = solutionCoords([posB-1, posB], :);
        else
            coordsBefore = solutionCoords([posB-1, posB, posB+1], :);
        end
      if size(coordsBefore,1)==3
        % 插入到 B 前面：形成 [B-1, A, B, B+1]
        coordsInsertBefore = [coordsBefore(1, :); newPoint; coordsBefore(2:end, :)];
        
        costBefore = vecnorm(coordsInsertBefore(1, :) - coordsInsertBefore(2, :), 2) + ...
                     vecnorm(coordsInsertBefore(3, :) - coordsInsertBefore(4, :), 2);
        

        % 插入到 B 后面：形成 [B-1, B, A, B+1]
        coordsInsertAfter = [coordsBefore(1:2, :); newPoint; coordsBefore(3, :)];
        costAfter = vecnorm(coordsInsertAfter(1, :) - coordsInsertAfter(2, :), 2) + ...
                    vecnorm(coordsInsertAfter(3, :) - coordsInsertAfter(4, :), 2);
      else
         if posB==1  %[B,B+1]
          % 插入到 B 前面：形成 [ A, B, B+1]
        coordsInsertBefore = [newPoint; coordsBefore(1:end, :)];
        
        costBefore = vecnorm(coordsInsertBefore(1, :) - coordsInsertBefore(2, :), 2) + ...
                     vecnorm(coordsInsertBefore(2, :) - coordsInsertBefore(3, :), 2);
        

        % 插入到 B 后面：形成 [B, A, B+1]
        coordsInsertAfter = [coordsBefore(1, :); newPoint; coordsBefore(2:end, :)];
        costAfter = vecnorm(coordsInsertAfter(1, :) - coordsInsertAfter(2, :), 2) + ...
                    vecnorm(coordsInsertAfter(2, :) - coordsInsertAfter(3, :), 2);
         else  %[B-1,B]
             % 插入到 B 前面：形成 [ B-1; A, B]
        coordsInsertBefore = [coordsBefore(1, :); newPoint; coordsBefore(2:end, :)];
        
        costBefore = vecnorm(coordsInsertBefore(1, :) - coordsInsertBefore(2, :), 2) + ...
                     vecnorm(coordsInsertBefore(2, :) - coordsInsertBefore(3, :), 2);
        

        % 插入到 B 后面：形成 [B-1,B, A]
        coordsInsertAfter = [coordsBefore(1:end, :); newPoint];
        costAfter = vecnorm(coordsInsertAfter(1, :) - coordsInsertAfter(2, :), 2) + ...
                    vecnorm(coordsInsertAfter(2, :) - coordsInsertAfter(3, :), 2);
         end
      end

        % 比较目标函数值，选择代价最小的插入方式
        if costBefore < costAfter
            % 插入到 B 前面
            solution = [solution(1:posB-1), ntarget+i, solution(posB:end)];
            solutionCoords=[solutionCoords(1:posB-1, :); newPoint; solutionCoords(posB:end, :)];
             % remainingPointsCoords = [remainingPointsCoords(1:minIdx-1, :); newPoint; remainingPointsCoords(minIdx:end, :)];
        else
            % 插入到 B 后面
            solution = [solution(1:posB), ntarget+i, solution(posB+1:end)];
            solutionCoords=[solutionCoords(1:posB, :); newPoint; solutionCoords(posB+1:end, :)];
           % remainingPointsCoords = [remainingPointsCoords(1:minIdx, :); newPoint; remainingPointsCoords(minIdx+1:end, :)];
        end


       %更新断点
         if ismember(closestPointIdx, path1)
             breakpoints(1)=breakpoints(1)+1;
             path1=[path1 ntarget+i];
         elseif ismember(closestPointIdx, path2)
             breakpoints(2)=breakpoints(2)+1;
             path2=[path2 ntarget+i];
         else
             
             path3=[path3 ntarget+i];
         end


        % 更新 remainingPoints 和 remainingPointsCoords
        remainingPoints = [remainingPoints, ntarget+i];
         remainingPointsCoords = [remainingPointsCoords; newPoint];
    end

    % 返回更新后的 solution 和 updatedCoords
    updatedSolution = [solution(1:ntarget+i),breakpoints];
    updatedCoords = solutionCoords;
end
