function s = IPGA(s, nCity, pMean)
    SegmentP = sort(randperm(nCity, 2));
    nVars = length(s);




    for k = 2:8
        s(k, :) = crossover(s(1, :), k-1);
    end
    for k = 9:10
        s(k, :) = variation(s(k-8, :));
    end
    function s = crossover(s, Rand) % 交叉函数
        switch Rand
            case 1 % FlipInsert
                s(SegmentP(1):SegmentP(2)) = s(SegmentP(2):-1:SegmentP(1));
            case 2 % SwapInsert
                s(SegmentP) = s(sort(SegmentP, 'descend'));
            case 3 % LSliInsert
                SegmentP = max([2, 3; SegmentP]);
                s1 = s(SegmentP(1)-1:SegmentP(2)-1);
                s2 = s([1:SegmentP(1)-2, SegmentP(2):nVars]);
                s(SegmentP(1):SegmentP(2)) = s1;
                s([1:SegmentP(1)-1, SegmentP(2)+1:nVars]) = s2;
            case 4 % RSliInsert
                SegmentP = min([nCity-2, nCity-1; SegmentP]);
                s1 = s(SegmentP(1)+1:SegmentP(2)+1);
                s2 = s([1:SegmentP(1), SegmentP(2)+2:nVars]);
                s(SegmentP(1):SegmentP(2)) = s1;
                s([1:SegmentP(1)-1, SegmentP(2)+1:nVars]) = s2;
            otherwise
                s(SegmentP(1):SegmentP(2)) = s(SegmentP(2):-1:SegmentP(1));
        end
    end    
    function s = variation(s) % 变异函数
        nCars = nVars - nCity;
        if rand > pMean
            s(nCity+1:end) = sort(randperm(nCity, nCars));
        else % 保证切割点位于中间
            nPoints = rand(1, nCars+1);
            nPoints = cumsum(round(nCity*(1+nPoints)./sum(1+nPoints)));
            s(nCity+1:end) = nPoints(1:end-1);
        end
        s(nCity+1:end) = max(2:nCars+1, s(nCity+1:end));
        s(nCity+1:end) = min(nCity-nCars:nCity-1, s(nCity+1:end));
    end
end

