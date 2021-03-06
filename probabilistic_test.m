function out = prob_test(z, varianceSquared, meanEst, alpha)
    out = zeros(1,length(z));
    for i = 3:length(z)
        deviation = abs(abs(meanEst(i)) - abs(z(i)));
        standerd_deviation = deviation / varianceSquared(i);
        if standerd_deviation > alpha
            out(i) = 1;
        else
            out(i) = 0;
        end
    end
end