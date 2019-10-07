function serr = std_error(data)
if length(data) == 1
    serr = 0;
    return
end

serr = nanstd(data)/sqrt(length(data));
end
