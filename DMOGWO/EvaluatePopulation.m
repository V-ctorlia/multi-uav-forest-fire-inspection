function z = EvaluatePopulation(population, inspectionPoints, startPoint, numDrones)
    % 评估种群的适应度，即目标函数的计算

        [f1, f2] = CalculateObjectives(population, inspectionPoints, startPoint, numDrones);

z = [f1 f2]';
end
