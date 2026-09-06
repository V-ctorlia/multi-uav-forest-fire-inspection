 function [flag] = check_constraint_horizontal_turning_angle(object,i)
            flag = 0;
            L1 = sqrt((object.Position(i,1)-object.Position(i-1,1))^2+(object.Position(i,2)-object.Position(i-1,2))^2);
            L2 = sqrt((object.Position(i-1,1)-object.Position(i-2,1))^2+(object.Position(i-1,2)-object.Position(i-2,2))^2);
            L3 = sqrt((object.Position(i,1)-object.Position(i-2,1))^2+(object.Position(i,2)-object.Position(i-2,2))^2);
            alpha = acosd((L1^2+L2^2-L3^2)/(2*L1*L2));
            if alpha < 75%alpha < 120
                % horizontal turning angle constraint have not satisfied
                flag = 1;
            end
        end