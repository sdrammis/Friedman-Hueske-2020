e15Dlx1D1Mice = {'3514', '3516', '3512', '4186'};
e15Dlx1D2Mice = {'3816', '3518', '3517', '3953'};
e15Mash1D1Mice = {'3356', '3899', '3846'};
e15Mash1D2Mice = {'3568', '3570', '3567', '3903'};

groupfn = @getgroupdatamice;
[e15Dlx1D1Strio, e15Dlx1D1Matrix, nMiceE15Dlx1D1] = groupfn(analysisdb, e15Dlx1D1Mice);
[e15Dlx1D2Strio, e15Dlx1D2Matrix, nMiceE15Dlx1D2] = groupfn(analysisdb, e15Dlx1D2Mice);
[e15Mash1D1Strio, e15Mash1D1Matrix, nMiceE15Mash1D1] = groupfn(analysisdb, e15Mash1D1Mice);
[e15Mash1D2Strio, e15Mash1D2Matrix, nMiceE15Mash1D2] = groupfn(analysisdb, e15Mash1D2Mice);

strioE15 = {[e15Dlx1D1Strio{1}; e15Dlx1D2Strio{1}], [e15Mash1D1Strio{1}; e15Mash1D2Strio{1}]};
matrixE15 = {[e15Dlx1D1Matrix{1}; e15Dlx1D2Matrix{1}], [e15Mash1D1Matrix{1}; e15Mash1D2Matrix{1}]};

figure;
plotbarsgrp({strioE15, matrixE15}, {'e15Dlx1', 'e15Mash1'});
legend('Strio Density', 'Matrix Density');
ylabel('# cells / mm^2');
title('MSN Densities - Mice Observation (E15)');

x1 = strioE11{1};
y1 = matrixE11{1};
[~,ttestp1] = ttest2(x1,y1);
signrankp1 = ranksum(x1,y1);
nS1 = sum(~isnan(x1));
nM1 = sum(~isnan(y1));
fprintf('DLX -- ttest p = %d \n', ttestp1);
fprintf('DLX-- signrank p = %d \n', signrankp1);
fprintf('# strio animals = %d, # matrix animals = %d \n', nS1, nM1);

x2 = strioE11{2};
y2 = matrixE11{2};
[~,ttestp2] = ttest2(x2,y2);
signrankp2 = ranksum(x2,y2);
nS2 = sum(~isnan(x2));
nM2 = sum(~isnan(y2));
fprintf('Mash1 -- ttest p = %d \n', ttestp2);
fprintf('Mash1 -- signrank p = %d \n', signrankp2);
fprintf('# strio animals = %d, # matrix animals = %d \n', nS2, nM2);

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
