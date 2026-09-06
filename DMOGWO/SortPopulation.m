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

function [pop, F] = SortPopulation(pop)

    % Sort based on Rank first (ascending order)
    [~, RSO] = sort([pop.Rank]);
    pop = pop(RSO);
    
    % Update fronts
    Ranks = [pop.Rank];
    MaxRank = max(Ranks);
    F = cell(MaxRank, 1);
    
    % Sort within each front based on Crowding Distance (descending order)
    for r = 1:MaxRank
        idx = find(Ranks == r); % Find all individuals with the same Rank
        if length(idx) > 1
            % Sort individuals in the same front by Crowding Distance (descending)
            [~, CDSO] = sort([pop(idx).CrowdingDistance], 'descend');
            pop(idx) = pop(idx(CDSO));
        end
        F{r} = idx; % Store the indices of individuals in the r-th front
    end

end
