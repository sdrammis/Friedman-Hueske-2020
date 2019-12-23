function meanCDF = avgcdf(ax, data, c, edges)
% Compute xlims
xlfig = figure;
hold on;
for i=1:length(data)
    datum = data{i};
    if isempty(datum) || all(isnan(datum))
        continue;
    end
    cdfplot(datum);
end
xl = xlim;
close(xlfig);

if isempty(edges)
    numBins = xl(2)-xl(1)+1;
%     numBins = 15;
    edges = xl(1):xl(2)/numBins:xl(2);
end

% Compute mean cdf
YData = [];
for i=1:length(data)
    datum = data{i};
    if isempty(datum)
        continue;
    end
    
    fh = figure;
    h = histogram(datum, edges);
    hvals = h.Values / sum(h.Values);
    YData = tern(isempty(YData), hvals, [YData; hvals]);
    close(fh);
end
binMidpoints = mean([edges(1:end-1);edges(2:end)]);
if size(YData, 1) == 1 % Only one data source provided.
    meanCDF = cumsum(YData);
    stderr = zeros(1,length(binMidpoints));
else
    csumYData = cumsum(mean(YData));
    meanCDF = csumYData / max(csumYData);
    stderr = std(YData,1) ./ sqrt(size(YData,1));
end

cldat = [binMidpoints' (meanCDF-stderr)' (meanCDF+stderr)' meanCDF'];
dg_plotShadeCL(ax, cldat, 'Color', c);
end
