function optimizedPos = neighborBy2opt(pos, inspectionPoints, startPoint, numDrones,ntarget)
    % 使用 2-opt 算法对给定位置进行优化
    optimizedPos = pos.Position(1:ntarget);
    newRoute.Position=pos.Position;
  
        for i = 1:length(optimizedPos)- 1
            for j = i + 2:length(optimizedPos)
                if j - i == 1
                    continue;
                end
                newRoute.Position(1:ntarget) = [optimizedPos(1:i-1) optimizedPos(j:-1:i) optimizedPos(j+1:end)];
                  newRoute.Cost=EvaluatePopulation(newRoute.Position, inspectionPoints, startPoint, numDrones);
                if Dominates(newRoute,pos)
                    optimizedPos = newRoute.Position(1:ntarget);
                 
                end
            end
        end

end
