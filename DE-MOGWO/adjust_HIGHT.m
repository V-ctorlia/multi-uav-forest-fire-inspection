function [object] = adjust_HIGHT(object,model)
 global xy
 global position1
 x=reshape(object.Position, 2, [])';
 if xy==1
     xx=[x(:,1) position1(2:model.n+1,2)  x(:,2)];
 else
     xx=[position1(2:model.n+1,1) x(:,1)  x(:,2)];
 end
           
object.Position=[model.start; xx; model.end];
 varRange = [-3,3];
          
            for i = 2 : size(object.Position,1)-1
                while i > 3 && check_constraint_horizontal_turning_angle(object,i) ~= 0
                    if rand(1) < 0.5
                        object.Position(i,2) = object.Position(i-1,2) + rand*(varRange(2)-varRange(1))+varRange(1);
                    else
                        object.Position(i,1) = object.Position(i-1,1) + rand*(varRange(2)-varRange(1))+varRange(1);                                                                        
                    end
                    object.Position = Evolve.check_boundary(object.Position,i,model);
                end
               
                    v1 = [model.H(floor(object.Position(i,2)),floor(object.Position(i,1)));
                    model.H(floor(object.Position(i,2)),ceil(object.Position(i,1)));
                    model.H(ceil(object.Position(i,2)),floor(object.Position(i,1)));
                    model.H(ceil(object.Position(i,2)),ceil(object.Position(i,1)))];


                        object.Position(i,3) = max(v1) + model.safeH;
                
                while check_constraint_vertical_turning_angle(object,i) ~= 0
                    j = i;
                    while j > 1
                        if object.Position(j,3) < object.Position(j-1,3)
                            object.Position(j,3) = object.Position(j,3) + rand*(object.Position(j-1,3)-object.Position(j,3));
                            if check_constraint_vertical_turning_angle(object,j) == 0
                                break;
                            end
                        else
                            object.Position(j-1,3) = object.Position(j-1,3) + rand*(object.Position(j,3)-object.Position(j-1,3));
                            if check_constraint_vertical_turning_angle(object,j) == 0
                                if j > 2 && check_constraint_vertical_turning_angle(object,j-1) == 0
                                    break;
                                else
                                    j = j - 1;
                                end
                            end
                                
                        end
                        
                    end
                end
            end
            object.Position(end,3) = model.end(3);
             middleRows = object.Position(2:end-1, :);
              if xy==1
                middleRows=[middleRows(:,1) middleRows(:,3)];
            else
                middleRows=[middleRows(:,2) middleRows(:,3)];
            end


            object.Position=reshape(middleRows', 1, []);
        end
        
