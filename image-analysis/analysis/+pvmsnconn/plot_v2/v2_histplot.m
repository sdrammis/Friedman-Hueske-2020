load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/miceType.mat');
data = load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/pv_msn/data/dataTable_v3.mat');
T = data.data;
T.Properties.VariableNames = {'mouseID', 'health', 'striosomality', ...
    'learned', 'file', 'numBlobs', 'cellAreaPixels' };

strioWTL = get_mice(miceType, 'striosomality', "Strio", 'health', "WT", 'learned');
strioWTN = get_mice(miceType, 'striosomality', "Strio", 'health', "WT", 'not-learned');
strioHDN = get_mice(miceType, 'striosomality', "Strio", 'health', "HD", 'not-learned');
matrixWTL = get_mice(miceType, 'striosomality', "Matrix", 'health', "WT", 'learned');
matrixWTN = get_mice(miceType, 'striosomality', "Matrix", 'health', "WT", 'not-learned');
matrixHDN = get_mice(miceType, 'striosomality', "Matrix", 'health', "HD", 'not-learned');

datSWTL = get_mice_data(T, strioWTL);
datSWTN = get_mice_data(T, strioWTN);
datSHDN = get_mice_data(T, strioHDN);
datMWTL = get_mice_data(T, matrixWTL);
datMWTN = get_mice_data(T, matrixWTN);
datMHDN = get_mice_data(T, matrixHDN);

figure;
subplot(1,2,1);
plot_group(datSWTL, datSWTN, datSHDN);
title('Strio Hist');
xlabel('# Dots / Cell Area');
ylabel('Mouse Average');
subplot(1,2,2);
plot_group(datMWTL, datMWTN, datMHDN);
title('Matrix Hist');
xlabel('# Dots / Cell Area');
ylabel('Mouse Average');

function plot_group(datWTL, datWTN, datHDN)
dat = [datWTL datWTN datHDN];
numBins = 30;
xmax = max(cellfun(@max, dat(~cellfun('isempty',dat))));
binEdges = 0:xmax/numBins:xmax;
binMidpts = mean([binEdges(1:end-1);binEdges(2:end)]);

[hWTL, eWTL] = get_avg_hist(datWTL, binEdges);
[hWTN, eWTN] = get_avg_hist(datWTN, binEdges);
[hHDN, eHDN] = get_avg_hist(datHDN, binEdges);

c = {[0.6 0.6 0.6], [0.6 0.9 0.6], [0.3 .7 0.9]};
hold on;
b = bar(binMidpts, [hWTL' hWTN' hHDN']);
b(1).FaceColor = c{1};
b(2).FaceColor = c{2};
b(3).FaceColor = c{3};
errorbar(binMidpts-0.15*10^-4, hWTL, zeros(size(eWTL)), eWTL, 'LineWidth', 1.5, 'Color', c{1});
errorbar(binMidpts, hWTN, zeros(size(eWTN)), eWTN, 'LineWidth', 1.5, 'Color', c{2});
errorbar(binMidpts+0.15*10^-4, hHDN, zeros(size(eHDN)), eHDN, 'LineWidth', 1.5, 'Color', c{3});
hold off;
legend('WTL', 'WTNL', 'HDNL');
end

function [m, e] = get_avg_hist(dat, edges)
vals = [];
for i=1:length(dat)
    datum = dat{i};
    if isempty(datum)
        continue;
    end
    
    fh = figure;
    h = histogram(datum, edges);
    vals = tern(isempty(vals), h.Values, [vals; h.Values]);
    close(fh);
end

m = mean(vals,1);
if size(vals,1) == 1
    e = zeros(1,size(vals,2));
else
    e = std(vals,1) ./ sqrt(size(vals,1));
end
end
