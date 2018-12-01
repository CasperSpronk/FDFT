function [Output_Test2 Average] = Averaged_Deterministic_Limit(z, Upper_Limit, Lower_Limit, W)
Output_Test2 = zeros(1,length(z));
Average = zeros(1,length(z));
    for i = 1:length(z)
        if i > W
            sumW = sum(z(i-W:i));
            test = sumW/(W+1);
            
        else
            sumW = sum(z(1:i));
            test = sumW/i;
        end
        
        if abs(test) > Upper_Limit
            Output_Test2(i) = 1;
            
        else if abs(test) < Lower_Limit
            Output_Test2(i) = 1;
        end
        Average(i) = test;
    end
end
    