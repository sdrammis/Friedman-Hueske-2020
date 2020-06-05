function [m, lowCL, highCL] = get_dist_stats(data)
    if size(data,1) ~= 1
        std_ = nanstd(data);
        m = nanmean(data);
    else
        std_ = data;
        m = data;
    end
    lowCL = m - std_ / sqrt(size(data, 1));
    highCL = m + std_ / sqrt(size(data, 1));
end