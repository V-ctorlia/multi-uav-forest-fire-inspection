function population = initialize_population(num_tasks, pop_size, start_point, task_coords)
    % num_tasks: 任务点数量 (20)
    % pop_size: 种群规模 (NSGA-II中的种群大小)
    % start_point: 起点坐标 [x, y]
    % task_coords: 所有任务点的坐标矩阵 [num_tasks, 2]

    % 初始化种群, 每个个体为1x22维 (前20维是任务序列, 后2维是断点)
    population = zeros(pop_size, num_tasks + 2);

    % 领域搜索生成一半的种群
    for i = 1:floor(pop_size / 2)
        % 1. 从起点开始选择最近的任务点
        available_tasks = 1:num_tasks;
        task_sequence = zeros(1, num_tasks);
        current_point = start_point;

        for j = 1:num_tasks
            % 选择最近的任务点
            distances = sqrt(sum((task_coords(available_tasks, :) - current_point) .^ 2, 2));
            [~, idx] = min(distances);
            closest_task = available_tasks(idx);

            % 将最近任务点加入序列
            task_sequence(j) = closest_task;
            current_point = task_coords(closest_task, :);

            % 从可用任务中移除已选任务
            available_tasks(idx) = [];
        end

        % 2. 随机交换两个任务点以增加多样性
        swap_idx = randperm(num_tasks, 2);
        task_sequence(swap_idx) = task_sequence(flip(swap_idx));

        % 3. 随机生成两个断点, 用于分配给3架无人机
        breakpoints = sort(randperm(num_tasks, 2));

        % 将任务序列和断点合并为一个个体
        population(i, :) = [task_sequence, breakpoints];
    end

    % 随机生成剩余一半的种群
    for i = floor(pop_size / 2) + 1:pop_size
        % 随机生成任务序列
        task_sequence = randperm(num_tasks);

        % 随机生成两个断点
        breakpoints = sort(randperm(num_tasks, 2));

        % 将任务序列和断点合并为一个个体
        population(i, :) = [task_sequence, breakpoints];
    end
end

