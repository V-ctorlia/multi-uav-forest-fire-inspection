function [pop,scores_pop] = selecttaskpoint(population,task)
%SELECTTASKPOINT 此处显示有关此函数的摘要
%   此处显示详细说明
numDrones=3;
n=size(population,1);
m=ceil(length(task)/numDrones);

mtask=m.*ones(1,numDrones);

evaluation_scores = zeros(1, numDrones);
sumlength=zeros(n,numDrones);
 scores_pop=zeros(n, 1);

for i=1:n
    dronePaths = SplitSolutionByDrones(population(i,:), numDrones);

    for j=1:numDrones
           task_sequence=zeros(1,1);
           path=dronePaths{1,j};
          for h = 1:length(path)
              task_sequence(h) = task(path(h)).rank;
   
          end
      
          task_length = length(task_sequence);
          sumlength(i,j)=task_length;
          % 生成评价向量（低-高-低模式）
          eval_vector = [1:ceil(task_length/2), floor(task_length/2):-1:1];
           % 计算差值总和作为评价得分（越小越符合低-高-低模式）
          evaluation_scores(j) = sum(abs(task_sequence - eval_vector));
    end
     scores_pop(i)=sum( evaluation_scores)+sum(abs(mtask-sumlength(i,:)));
    % scores_pop(i)=sum( evaluation_scores);
end
% 对评分进行排序
[sorted_scores, sorted_indices] = sort(scores_pop); 

% 选取评分最小的一半个体
half_n = floor(n / 2); % 选取前一半的个体数量
pop = population(sorted_indices(1:half_n), :); % 选取得分最低的前一半个体
pop_scores = sorted_scores(1:half_n); % 对应的最小得分
end

