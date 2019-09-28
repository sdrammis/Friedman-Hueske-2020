load('./dbs/miceType.mat');
data = load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/pv_msn/data/dataTable_v3.mat');
T = data.data;
T.Properties.VariableNames = {'mouseID', 'health', 'striosomality', ...
    'learned', 'file', 'numBlobs', 'cellAreaPixels' };

strioWTL = utils.get_mice(miceType, 'striosomality', "Strio", 'health', "WT", 'learned');
strioWTN = utils.get_mice(miceType, 'striosomality', "Strio", 'health', "WT", 'not-learned');
strioHDN = utils.get_mice(miceType, 'striosomality', "Strio", 'health', "HD", 'not-learned');
matrixWTL = utils.get_mice(miceType, 'striosomality', "Matrix", 'health', "WT", 'learned');
matrixWTN = utils.get_mice(miceType, 'striosomality', "Matrix", 'health', "WT", 'not-learned');
matrixHDN = utils.get_mice(miceType, 'striosomality', "Matrix", 'health', "HD", 'not-learned');

datSWTL = getblobs(T, strioWTL);
datSWTN = getblobs(T, strioWTN);
datSHDN = getblobs(T, strioHDN);
datMWTL = getblobs(T, matrixWTL);
datMWTN = getblobs(T, matrixWTN);
datMHDN = getblobs(T, matrixHDN);

%% Plot CDF

cs = {[0.6 0.6 0.6], [0.6 0.9 0.6], [0.3 0.7 0.9]};
f = figure;
subplot(1, 2, 1);
hold on;
plot.avgcdf(gca, datSWTL, cs{1}, []);
plot.avgcdf(gca, datSWTN, cs{2}, []);
plot.avgcdf(gca, datSHDN, cs{3}, []);
plot.clegend(cs, {'WT Learned', 'WT Not Learned', 'HD Not Learned'}, 'northeast');
title('Strio');
xlabel('# Putative Terminals');
subplot(1, 2, 2);
hold on;
plot.avgcdf(gca, datMWTL, cs{1}, []);
% plot.avgcdf(gca, datMWTN, cs{2});
plot.avgcdf(gca, datMHDN, cs{3}, []);
plot.clegend({cs{1}, cs{3}}, {'WT Learned', 'HD Not Learned'}, 'northeast');
title('Matrix');
xlabel('# Putative Terminals');

%% Plot Bars
datStrioMean = {cellfun(@mean, datSWTL), cellfun(@mean, datSWTN), cellfun(@mean,datSHDN)};
plot.plotbars(datStrioMean, {'WT Learned', 'WT Not Learned', 'HD Not Learned'}, [cs{1}; cs{2}; cs{3}]);
title('Striosomes');
ylabel('# Putative Terminals Per Animal');

%% Helper functions
function data = getblobs(T, mice)
n = length(mice);
data = cell(1,n);
for i=1:n
    mouse = mice(i);
    mouseT = T(T.mouseID == str2double(mouse.ID),:);
    data{i} = mouseT.numBlobs;
end
end
