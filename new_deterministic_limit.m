function [out average] = deter(x,limit,k)
out = zeros(1,length(x));
average = zeros(1,length(x))
    for i = 1:length(x)
        if i > k
%             disp("i should be greater than k")
%             disp(i)
%             disp(k)
            hold = x(i-k:i);
            test = sum(hold)/k;
            
        else
            hold = x(1:i);
            test = sum(hold)/i;
        end
        if abs(test) > limit
            out(i) = 1;
        end
        average(i) = test;
    end
end
    