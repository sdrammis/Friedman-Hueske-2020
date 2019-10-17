function ret = zscore_baseline(data, base)
m = mean(base);
s = std(base);
ret = arrayfun(@(x) (x - m) / s, data);
end

