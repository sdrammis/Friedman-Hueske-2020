function avgpdf(data, c, edges)
binMidpts = mean([edges(1:end-1);edges(2:end)]);

hists = [];
errs = [];
for i=1:length(data)
    dat = data{i};
    [m, e] = getavgpdf(dat, edges); 
    hists = [hists; m];
    errs = [errs; e];    
end

b = bar(binMidpts, hists');
hold on;
for i=1:length(data)
color = c(i,:);
h = hists(i,:);
e = errs(i,:);
xData = b(i).XData + b(i).XOffset;

b(i).FaceColor = color;
errorbar(xData, h, zeros(size(e)), e, 'LineWidth', 1.5, 'Color', color);
end
end

function [m, e] = getavgpdf(dat, edges)
vals = [];
for i=1:length(dat)
    datum = dat{i};
    if isempty(datum)
        continue;
    end
    
    fh = figure;
    h = histogram(datum, edges);
    val = h.Values / sum(h.Values);
    vals = utils.tern(isempty(vals), val, [vals; val]);
    close(fh);
end

m = mean(vals,1);
if size(vals,1) == 1
    e = zeros(1,size(vals,2));
else
    e = std(vals,1) ./ sqrt(size(vals,1));
end
end