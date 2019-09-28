% Version 2 of pv->msn onnection graphs
load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/miceType.mat');
data = load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/pv_msn/data/dataTable_v3.mat');
T = data.data;
T.Properties.VariableNames = {'mouseID', 'health', 'striosomality', ...
    'learned', 'file', 'numBlobs', 'cellAreaPixels' };

% Get mouseIDs by group
strioWTL = get_mice(miceType, 'striosomality', "Strio", 'health', "WT", 'learned');
strioWTNL = get_mice(miceType, 'striosomality', "Strio", 'health', "WT", 'not-learned');
strioHDNL = get_mice(miceType, 'striosomality', "Strio", 'health', "HD", 'not-learned');
matrixWTL = get_mice(miceType, 'striosomality', "Matrix", 'health', "WT", 'learned');
matrixWTNL = get_mice(miceType, 'striosomality', "Matrix", 'health', "WT", 'not-learned');
matrixHDNL = get_mice(miceType, 'striosomality', "Matrix", 'health', "HD", 'not-learned');

figure;
subplot(2,3,1);
[cdfStrioWTL, nStrioWTL] = plot_cdf(get_mice_data(T, strioWTL));
title('Strio WTL'), xlabel('# Blobs per cell area px');
subplot(2,3,2);
[cdfStrioWTNL, nStrioWTNL] = plot_cdf(get_mice_data(T, strioWTNL));
title('Strio WTNL'), xlabel('# Blobs per cell area px');
subplot(2,3,3);
[cdfStrioHDNL, nStrioHDNL] = plot_cdf(get_mice_data(T, strioHDNL));
title('Strio HDNL'), xlabel('# Blobs per cell area px');
subplot(2,3,4);
[cdfMatrixWTL, nMatrixWTL] = plot_cdf(get_mice_data(T, matrixWTL));
title('Matrix WTL'), xlabel('# Blobs per cell area px');
subplot(2,3,5);
[cdfMatrixWTNL, nMatrixWTNL] = plot_cdf(get_mice_data(T, matrixWTNL));
title('Matrix WTNL'), xlabel('# Blobs per cell area px');
subplot(2,3,6);
[cdfMatrixHDNL, nMatrixHDNL] = plot_cdf(get_mice_data(T, matrixHDNL));
title('Matrix HDNL'), xlabel('# Blobs per cell area px');

ksStrioWTL_StrioWTNL = kstest2cdf(cdfStrioWTL, cdfStrioWTNL, nStrioWTL, nStrioWTNL);
ksStrioWTL_StrioHDNL = kstest2cdf(cdfStrioWTL, cdfStrioHDNL, nStrioWTL, nStrioHDNL);
ksStrioWTNL_StrioHDNL = kstest2cdf(cdfStrioWTNL, cdfStrioHDNL, nStrioWTNL, nStrioHDNL);
ksMatrixWTL_MatrixWTNL = kstest2cdf(cdfMatrixWTL, cdfMatrixWTNL, nMatrixWTL, nMatrixWTNL);
ksMatrixWTL_MatrixHDNL = kstest2cdf(cdfMatrixWTL, cdfMatrixHDNL, nMatrixWTL, nMatrixHDNL);
ksMatrixWTNL_MatrixHDNL = kstest2cdf(cdfMatrixWTNL, cdfMatrixHDNL, nMatrixWTNL, nMatrixHDNL);
ksStrioWTL_MatrixWTL = kstest2cdf(cdfStrioWTL, cdfMatrixWTL, nStrioWTL, nMatrixWTL);
ksStrioWTNL_MatrixWTNL = kstest2cdf(cdfStrioWTNL, cdfMatrixWTNL, nStrioWTNL, nMatrixWTNL);
ksStrioHDNL_MatrixHDNL = kstest2cdf(cdfStrioHDNL, cdfMatrixHDNL, nStrioHDNL, nMatrixHDNL);

sgtitle([
   'P-Vals' newline ...
   'Strio: ' ...
   sprintf('WTLvWTNL=%.3f ', ksStrioWTL_StrioWTNL) ...
   sprintf('WTLvHDNL=%.3f ', ksStrioWTL_StrioHDNL) ...
   sprintf('WTNLvHDNL=%.3f', ksStrioWTNL_StrioHDNL) newline ...
   'Matrix: ' ...
   sprintf('WTLvWTNL=%.3f ', ksMatrixWTL_MatrixWTNL) ...
   sprintf('WTLvHDNL=%.3f ', ksMatrixWTL_MatrixHDNL)  ...
   sprintf('WTNLvHDNL=%.3f', ksMatrixWTNL_MatrixHDNL) newline ...
   sprintf('StrioWTL v MatrixWTL p=%.3f -- ', ksStrioWTL_MatrixWTL) ...
   sprintf('StrioWTNL v MatrixWTNL p=%.3f -- ', ksStrioWTNL_MatrixWTNL) ...
   sprintf('StrioHDNL v MatrixHDNL p=%.3f', ksStrioHDNL_MatrixHDNL)
]);


function [meanCDF, n] = plot_cdf(data)
hold on;
for i=1:length(data)
    datum = data{i};
    if isempty(datum)
        continue;
    end
    c = cdfplot(datum);
    c.Color = [0.7 0.7 0.7];
    c.LineWidth = 1.5;
end
grid off;

% Compute mean cdf
xl = xlim;
numBins = 100;
edges = xl(1):xl(2)/numBins:xl(2);
YData = [];
for i=1:length(data)
    datum = data{i};
    if isempty(datum)
        continue;
    end
    
    fh = figure;
    h = histogram(datum, edges);
    YData = tern(isempty(YData), h.Values, [YData; h.Values]);
    close(fh);
end
binMidpoints = mean([edges(1:end-1);edges(2:end)]);
csumYData = cumsum(mean(YData));
meanCDF = csumYData / max(csumYData);
plot(binMidpoints, meanCDF, 'LineWidth', 2, 'Color', 'b');

% Compute average n
n = sum(cellfun(@length, data)) / sum(~cellfun(@isempty, data));
end

function pValue = kstest2cdf(cdf1, cdf2, n1, n2)
deltaCDF  =  abs(cdf1 - cdf2);
KSstatistic   =  max(deltaCDF);
n      =  n1 * n2 /(n1 + n2);
lambda =  max((sqrt(n) + 0.12 + 0.11/sqrt(n)) * KSstatistic , 0);
j       =  (1:101)';
pValue  =  2 * sum((-1).^(j-1).*exp(-2*lambda*lambda*j.^2));
pValue  =  min(max(pValue, 0), 1);
end

