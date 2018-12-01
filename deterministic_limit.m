function Output_Test1 = Deterministic_Limit(z,Upper_Limit,Lower_Limit)
Output_Test1 = zeros(1,length(z));
    for i = 1:length(z)
        if abs(z(i)) > Upper_Limit
            Output_Test1(i) = 1;
        else if abs(z(i)) < Lower_Limit
            Output_Test1(i) = 1;
        end
    end
end
    