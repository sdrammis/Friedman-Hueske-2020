function [begin_x, end_x, slope] = pair_slope_analysis(fitobj, dat_x, num_samples, flat_thre)
    xmin = min(dat_x);
    xmax = max(dat_x);
    x = linspace(xmin, xmax, num_samples);
    diffs = differentiate(fitobj,x);
    begin_x = 1;
    end_x = num_samples;
    ix = 1;
    while ix < num_samples && diffs(ix) >= flat_thre
        ix = ix + 1;
    end
    begin_x = x(ix);
    while ix <= num_samples && diffs(ix) < flat_thre 
        ix = ix + 1;
    end
    end_x = x(ix - 1);
    slope = (fitobj(end_x) - fitobj(begin_x)) / (end_x - begin_x);
end