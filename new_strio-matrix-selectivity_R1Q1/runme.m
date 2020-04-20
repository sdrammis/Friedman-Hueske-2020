COLORS = cbrewer('qual', 'Set2', 10);

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

strioDlxE11 = [e11Dlx1D1Strio{1}; e11Dlx1D2Strio{1}];
matrixDlxE11 = [e11Dlx1D1Matrix{1}; e11Dlx1DMatrix{1}];
strioMashE11 = [e11Mash1D1Strio{1}; e11Mash1D2Strio{1}];
matrixMashE11 = [e11Mash1D1Matrix{1}; e11Mash1D2Matrix{1}];

strioDlxE15 = [e15Dlx1D1Strio{1}; e15Dlx1D2Strio{1}];
matrixDlxE15 = [e15Dlx1D1Matrix{1}; e15Dlx1D2Matrix{1}];
strioMashE15 = [e15Mash1D1Strio{1}; e15Mash1D2Strio{1}];
matrixMashE15 = [e15Mash1D1Matrix{1}; e15Mash1D2Matrix{1}];

ratioDlxE11 = (strioDlxE11 - matrixDlxE11) ./ (strioDlxE11 + matrixDlxE11);
ratioMashE11 = (strioMashE11 - matrixMashE11) ./ (strioMashE11 + matrixMashE11);
ratioDlxE15 = (strioDlxE15 - matrixDlxE15) ./ (strioDlxE15 + matrixDlxE15);
ratioMashE15 = (strioMashE15 - matrixMashE15) ./ (strioMashE15 + matrixMashE15);

figure;
plotbars({ratioDlxE11, ratioMashE11, ratioDlxE15, ratioMashE15}, ...
    {'e11Dlx1', 'e11Mash1', 'e15Dlx1', 'e15Mash1'}, COLORS);
ylabel('# cells / mm^2 -- (S-M)/(S+M)');
title('MSN Densities - Strio v Matrix');

A = [ratioDlxE11; ratioMashE11; ratioDlxE15; ratioMashE15];
g = {...
    repmat({'DlxE11'}, 1, length(ratioDlxE11)), ...
    repmat({'MashE11'}, 1, length(ratioMashE11)), ...
    repmat({'DlxE15'}, 1, length(ratioDlxE15)), ...
    repmat({'MashE15'}, 1, length(ratioMashE15))};
[p,tbl,stats] = anova1(A,horzcat(g{:}),'off');



disp(p);

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

