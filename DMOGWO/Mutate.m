%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function y = Mutate(child,mu)

   % 简单变异：随机交换两个巡检点
    numPoints=size(child,1);
    if rand < mu
        idx1 = randi([1, numPoints]); % 去掉起点和终点
        idx2 = randi([1, numPoints]);
        y = child;
       y([idx1, idx2]) = child([idx2, idx1]);
    else
        y = child;
    end

end