 function object=initialize(object,model)
 global xy
 global position1
           size=model.n+1;
          position1=zeros(model.n+2,3);
          position1(1,:) = model.start;
          position1(model.n+2,:) = model.end;
          object.Position=zeros(model.n,2);
         
           
            boundx = abs(model.end(1)-model.start(1));
            boundy = abs(model.end(2)-model.start(2));
            
            varRangex = [- boundx/2,boundx/2];
            varRangey = [- boundy/2,boundy/2];
            i = 2;
            if boundx<boundy %平分y轴，迭代x轴
                 object.Position(1,1) = model.start(1);
                 object.Position(model.n+2,1) = model.end(1);
                xy=1;
                while i < model.n+2

                    %生成x
                    if object.Position(1,1)<object.Position(end,1)
                        object.Position(i,1) = object.Position(i-1,1)+boundx/size + rand(1)*(varRangex(2)-varRangex(1))+varRangex(1);
                    else
                        object.Position(i,1) = object.Position(i-1,1)-boundx/size + rand(1)*(varRangex(2)-varRangex(1))+varRangex(1);
                    end
                    i=i+1;
                end
            else %平分x轴，迭代y轴
                xy=0;
                object.Position(1,1) = model.start(2);
                 object.Position(model.n+2,1) = model.end(2);
                while i < model.n+2

                    %生成y
                    if object.Position(1,1)<object.Position(end,1)
                        object.Position(i,1) = object.Position(i-1,1)+boundy/size + rand(1)*(varRangey(2)-varRangey(1))+varRangey(1);
                    else
                        object.Position(i,1) = object.Position(i-1,1)-boundy/size + rand(1)*(varRangey(2)-varRangey(1))+varRangey(1);
                    end

                    i=i+1;
                end
            end

            if xy==1
                position1(2:model.n+1,1)=object.Position(2:model.n+1,1);%带入x
                b=linspace(model.start(2), model.end(2), model.n+2);%均匀生成y
                position1(2:model.n+1,2)=b(2:model.n+1)';%带入y
            else
                position1(2:model.n+1,2)=object.Position(2:model.n+1,1);%带入y
                b=linspace(model.start(1), model.end(1), model.n+2);%均匀生成x
                position1(2:model.n+1,1)=b(2:model.n+1)';%带入x
            end



            
            
            a = position1(:,1);
            a(a < model.ymin) = model.xmin;
            a(a > model.ymax) = model.ymax;
            position1(:,1) = a;
            a = position1(:,2);
            a(a < model.ymin) = model.xmin;
            a(a > model.ymax) = model.ymax;
            position1(:,2) = a;
            object.Position=position1;

            
            object = adjust_constraint_turning_angle(object,model);
            middleRows = object.Position(2:end-1, :);
            if xy==1
                middleRows=[middleRows(:,1) middleRows(:,3)];
            else
                middleRows=[middleRows(:,2) middleRows(:,3)];
            end

            object.Position=reshape(middleRows', 1, []);
            

        end
