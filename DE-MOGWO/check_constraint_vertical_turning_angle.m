function [flag] = check_constraint_vertical_turning_angle(object,i)
            flag = 0;
            L1 = sqrt((object.Position(i,1)-object.Position(i-1,1))^2+(object.Position(i,2)-object.Position(i-1,2))^2);
%             L1 = sqrt((object.rnvec(x2,1)-object.rnvec(x1,1))^2+(object.rnvec(x2,2)-object.rnvec(x1,2))^2);
            beta = atand(abs(object.Position(i,3)-object.Position(i-1,3))/L1);
            if beta > 60
                % vertical turning angle constraint have not satisfied
                flag = 1;
            end
        end