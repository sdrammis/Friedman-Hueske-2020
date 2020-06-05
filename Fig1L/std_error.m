function serr = std_error(data)

serr = nanstd(data)/sqrt(length(data));