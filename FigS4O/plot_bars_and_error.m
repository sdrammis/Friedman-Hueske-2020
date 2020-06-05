function plot_bars_and_error(data)

meanResponse = nanmean(data,1);
if size(data,1) > 1
    serr = std_error(data);
else
    serr = [0 0 0];
end
plot(meanResponse)
errorbar(meanResponse,serr)
end