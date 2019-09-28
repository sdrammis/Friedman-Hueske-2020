function cdfcont(dat, names, colors)
n = length(dat);

xl1 = 0;
xl2 = max([dat{:}]);
% numBins = xl2-xl1+1;
numBins = 15;
edges = xl1:xl2/numBins:xl2;
binMidpoints = mean([edges(1:end-1);edges(2:end)]);

hold on;
for b=1:n
   datum = dat{b};
   if isempty(datum)
       continue;
   end
   
    fh = figure;
    h = histogram(datum, edges);
    hvals = h.Values / sum(h.Values);
    close(fh);
    
    csum = cumsum(hvals);
    [ys, idxs] = unique(csum);
    xs = binMidpoints(idxs);
    plot(xs, ys, '-*', 'Color', colors(b,:));
end

legend(names);
end



% function cdfcont(dat, names, colors)
% n = length(dat);
% 
% hold on;
% for b=1:n
%    datum = dat{b};
%    if isempty(datum)
%        continue;
%    end
%    
%     fh = figure;
%     c = cdfplot(datum);
%     xs = c.XData(1:2:end);
%     ys = c.YData(1:2:end);
%     close(fh);
% 
%     plot(xs, ys, '-*', 'Color', colors(b,:));
% end
% 
% legend(names);
% end
% 

