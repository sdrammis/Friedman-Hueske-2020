load('./dbs/analysisdb-densitiestmp.mat');
load('/home/sdrammis/Dropbox (MIT)/striomatrix-analysis/dbs/micedb.mat');

e11Dlx1D1Mice = {'3447', '4233', '3348', '4229'};
e11Dlx1D2Mice = {'3337', '3343', '3084', '3085'};
e11Mash1D1Mice = {'3552', '3545', '3535', '3536'};
e11Mash1D2Mice = {'3128', '3131', '3130', '3562'};
e15Dlx1D1Mice = {'3514', '3516', '3512', '4186'};
e15Dlx1D2Mice = {'3816', '3518', '3517', '3953'};
e15Mash1D1Mice = {'3356', '3899', '3846'};
e15Mash1D2Mice = {'3568', '3570', '3567', '3903'};

groupfn = @getgroupdatamice;

[e11Dlx1D1Strio, e11Dlx1D1Matrix, nMiceE11DlxD1] = groupfn(analysisdb, e11Dlx1D1Mice);
[e11Dlx1D2Strio, e11Dlx1DMatrix, nMiceE11Dlx1D2] = groupfn(analysisdb, e11Dlx1D2Mice);
[e11Mash1D1Strio, e11Mash1D1Matrix, nMiceE11Mash1D1] = groupfn(analysisdb, e11Mash1D1Mice);
[e11Mash1D2Strio, e11Mash1D2Matrix, nMiceE11Mash1D2] = groupfn(analysisdb, e11Mash1D2Mice);
[e15Dlx1D1Strio, e15Dlx1D1Matrix, nMiceE15Dlx1D1] = groupfn(analysisdb, e15Dlx1D1Mice);
[e15Dlx1D2Strio, e15Dlx1D2Matrix, nMiceE15Dlx1D2] = groupfn(analysisdb, e15Dlx1D2Mice);
[e15Mash1D1Strio, e15Mash1D1Matrix, nMiceE15Mash1D1] = groupfn(analysisdb, e15Mash1D1Mice);
[e15Mash1D2Strio, e15Mash1D2Matrix, nMiceE15Mash1D2] = groupfn(analysisdb, e15Mash1D2Mice);

% plotgroup(e11Dlx1D1Strio, e11Dlx1D1Matrix, 'e11Dlx1D1', nMiceE11DlxD1);
% plotgroup(e11Dlx1D2Strio, e11Dlx1DMatrix, 'e11Dlx1D2', nMiceE11Dlx1D2);
% plotgroup(e11Mash1D1Strio, e11Mash1D1Matrix, 'e11Mash1D1', nMiceE11Mash1D1);
% plotgroup(e11Mash1D2Strio, e11Mash1D2Matrix, 'e11Mash1D2', nMiceE11Mash1D2);
% plotgroup(e15Dlx1D1Strio, e15Dlx1D1Matrix, 'e15Dlx1D1', nMiceE15Dlx1D1);
% plotgroup(e15Dlx1D2Strio, e15Dlx1D2Matrix, 'e15Dlx1D2', nMiceE15Dlx1D2);
% plotgroup(e15Mash1D1Strio, e15Mash1D1Matrix, 'e15Mash1D1', nMiceE15Mash1D1);
% plotgroup(e15Mash1D2Strio, e15Mash1D2Matrix, 'e15Mash1D2', nMiceE15Mash1D2);
% close all;

datDiffs = {
  e11Dlx1D1Strio{1} - e11Dlx1D1Matrix{1}, ...
  e11Dlx1D2Strio{1} - e11Dlx1DMatrix{1}, ...
  e11Mash1D1Strio{1} - e11Mash1D1Matrix{1}, ...
  e11Mash1D2Strio{1} - e11Mash1D2Matrix{1}, ...
  e15Dlx1D1Strio{1} - e15Dlx1D1Matrix{1}, ...
  e15Dlx1D2Strio{1} - e15Dlx1D2Matrix{1}, ...
  e15Mash1D1Strio{1} - e15Mash1D1Matrix{1}, ...
  e15Mash1D2Strio{1} - e15Mash1D2Matrix{1}, ...
};
% plotalldiffs(datDiffs, {'e11Dlx1D1', 'e11Dlx1D2', 'e11Mash1D1', 'e11Mash1D2', ...
%    'e15Dlx1D1', 'e15Dlx1D2', 'e15Mash1D1', 'e15Mash1D2'});

allStrio = {...
    [e11Dlx1D1Strio{1}; e11Dlx1D2Strio{1}], [e11Mash1D1Strio{1}; e11Mash1D2Strio{1}], ...
    [e15Dlx1D1Strio{1}; e15Dlx1D2Strio{1}], [e15Mash1D1Strio{1}; e15Mash1D2Strio{1}]};
allMatrix = {...
    [e11Dlx1D1Matrix{1}; e11Dlx1DMatrix{1}], [e11Mash1D1Matrix{1}; e11Mash1D2Matrix{1}], ...
    [e15Dlx1D1Matrix{1}; e15Dlx1D2Matrix{1}], [e15Mash1D1Matrix{1}; e15Mash1D2Matrix{1}]};
plotall(allStrio, allMatrix, {'e11Dlx1', 'e11Mash1', 'e15Dlx1', 'e15Mash1'});


function plotall(strio, matrix, names)
figure;
plot.plotbarsgrp({strio, matrix}, names);

ttst = ones(1,length(strio));
for i=1:length(strio)
   [~, ttst(i)] = ttest(strio{i}, matrix{i});
end

legend('Strio Density', 'Matrix Density');
ylabel('# cells / mm^2');
title(['MSN Densities - Mice Observation' newline ...
    'ttest p-vals (in order) = ' num2str(ttst)]);
end

function plotalldiffs(diffs, names)
COLORS = cbrewer('qual', 'Set2', 10);

figure;
subplot(1,2,1);
plot.plotbars(diffs(1:4), names(1:4), COLORS);
title('E11 Animals');
subplot(1,2,2);
plot.plotbars(diffs(5:8), names(5:8), COLORS);
title('E15 Animals');
sgtitle('Overall Strio Densitiy - Matrix Density');
end

function plotgroup(strio, matrix, groupname, nAnimals)
NAMES = {'All', 'TopLeft', 'TopMid', 'TopRight', 'BotLeft', 'BotMid', 'BotRight'};
COLORS = cbrewer('qual', 'Set2', 10);

nDat = length(strio);
diffs = cell(1,nDat);
for iDat=1:nDat
   diffs{iDat} =  strio{iDat} - matrix{iDat};
end

f = figure;
plot.plotbars(diffs, NAMES, COLORS);
% title(sprintf([groupname ' (Strio Densities - Matrix Densities)' ... 
%     newline '# slices = %d, # Animals = %d'], ...
%     length(diffs{1}), nAnimals));
title(sprintf([groupname ' (Strio Densities - Matrix Densities)' ... 
    newline '# Animals = %d'], nAnimals));
saveas(f, ['./tmp/figs/densities_prefinal/obs-mice-' lower(groupname) '.png']);
saveas(f, ['./tmp/figs/densities_prefinal/obs-mice-' lower(groupname) '.fig']);
end

function [datStrio, datMatrix, nAnimals] = getgroupdatamice(analysisdb, group)
datStrio = {[], [], [], [], [], [], []};
datMatrix = {[], [], [], [], [], [], []};
nAnimals = 0;

for iMouse=1:length(group)
   mouseID = group{iMouse};
   
   idxs = strcmp({analysisdb.mouseID}, mouseID) & ~strcmp({analysisdb.stack}, 'P');
   if nnz(idxs) == 0
       continue;
   end
   
   data = vertcat(analysisdb(idxs).msncounts);
   
   datStrio{1} = [datStrio{1}; nanmean(data{:,1} ./ data{:,15})];
   datStrio{2} = [datStrio{2}; nanmean(data{:,2} ./ data{:,16})];
   datStrio{3} = [datStrio{3}; nanmean(data{:,3} ./ data{:,17})];
   datStrio{4} = [datStrio{4}; nanmean(data{:,4} ./ data{:,18})];
   datStrio{5} = [datStrio{5}; nanmean(data{:,5} ./ data{:,19})];
   datStrio{6} = [datStrio{6}; nanmean(data{:,6} ./ data{:,20})];
   datStrio{7} = [datStrio{7}; nanmean(data{:,7} ./ data{:,21})];

   datMatrix{1} = [datMatrix{1}; nanmean(data{:,8} ./ data{:,22})];
   datMatrix{2} = [datMatrix{2}; nanmean(data{:,9} ./ data{:,23})];
   datMatrix{3} = [datMatrix{3}; nanmean(data{:,10} ./ data{:,24})];
   datMatrix{4} = [datMatrix{4}; nanmean(data{:,11} ./ data{:,25})];
   datMatrix{5} = [datMatrix{5}; nanmean(data{:,12} ./ data{:,26})];
   datMatrix{6} = [datMatrix{6}; nanmean(data{:,13} ./ data{:,27})];
   datMatrix{7} = [datMatrix{7}; nanmean(data{:,14} ./ data{:,28})];
   
   nAnimals = nAnimals + 1;
end
end

function [datStrio, datMatrix, nAnimals] = getgroupdata(analysisdb, group)
datStrio = {[], [], [], [], [], [], []};
datMatrix = {[], [], [], [], [], [], []};
nAnimals = 0;

for iMouse=1:length(group)
   mouseID = group{iMouse};
   
   idxs = strcmp({analysisdb.mouseID}, mouseID) & ~strcmp({analysisdb.stack}, 'P');
   if nnz(idxs) == 0
       continue;
   end
   
   data = vertcat(analysisdb(idxs).msncounts);
   
   datStrio{1} = [datStrio{1}; data{:,1} ./ data{:,15}];
   datStrio{2} = [datStrio{2}; data{:,2} ./ data{:,16}];
   datStrio{3} = [datStrio{3}; data{:,3} ./ data{:,17}];
   datStrio{4} = [datStrio{4}; data{:,4} ./ data{:,18}];
   datStrio{5} = [datStrio{5}; data{:,5} ./ data{:,19}];
   datStrio{6} = [datStrio{6}; data{:,6} ./ data{:,20}];
   datStrio{7} = [datStrio{7}; data{:,7} ./ data{:,21}];

   datMatrix{1} = [datMatrix{1}; data{:,8} ./ data{:,22}];
   datMatrix{2} = [datMatrix{2}; data{:,9} ./ data{:,23}];
   datMatrix{3} = [datMatrix{3}; data{:,10} ./ data{:,24}];
   datMatrix{4} = [datMatrix{4}; data{:,11} ./ data{:,25}];
   datMatrix{5} = [datMatrix{5}; data{:,12} ./ data{:,26}];
   datMatrix{6} = [datMatrix{6}; data{:,13} ./ data{:,27}];
   datMatrix{7} = [datMatrix{7}; data{:,14} ./ data{:,28}];
   
   nAnimals = nAnimals + 1;
end
end