function out = deter(x,limit)
out = zeros(1,length(x));
    for i = 1:length(x)
        if abs(x(i)) > limit
            out(i) = 1;
        end
    end
end
    