function population = initialize_population(num_tasks, pop_size, start_point, task_coords)
    % num_tasks: 任务点数量 (20)
    % pop_size: 种群规模 (NSGA-II中的种群大小)
    % start_point: 起点坐标 [x, y]
    % task_coords: 所有任务点的坐标矩阵 [num_tasks, 2]

    % 初始化种群, 每个个体为1x22维 (前20维是任务序列, 后2维是断点)
    population = zeros(pop_size, num_tasks + 2);

   

    for i =  1:pop_size
        % 随机生成任务序列
        task_sequence = randperm(num_tasks);

        % 随机生成两个断点
        breakpoints = sort(randperm(num_tasks, 2));

        % 将任务序列和断点合并为一个个体
        population(i, :) = [task_sequence, breakpoints];
    end
end

