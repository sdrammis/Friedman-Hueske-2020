function devalPlots(twdb)
% Author: QZ
% 08/26/2019
% crossPlotsDZPDeval_UPDATE1.m
% deval part3, dzp part2
%% Part I. Deval Part 3 Update. No binning. Each Mouse is a data point.
devalData = devalData_UPDATE1(twdb);
% only learned WT
matrixIDs = unique(twdb_lookup(table2struct(devalData),'mouseID',...
    'key','Health','WT','key','intendedStriosomality','Matrix',...
    'grade','learnedFirstTask',0,inf));
upToLearned = 0;
reversal = 0;
[matrixTrials,matrixFTrials,matrixRTones,matrixCTones,matrixN] = get_all_trials(twdb,...
    matrixIDs,upToLearned,reversal);
[~,mouseIDsMatrix,~,~,~,~,~,~,RTWater_M,RTSucrose_M,RTBase_M,...
    CTWater_M,CTSucrose_M,CTBase_M] = calcAndPlotDevalUPDATE2_QZ(twdb,...
    matrixIDs,matrixRTones,matrixCTones,matrixN,'Matrix',devalData);
p1deval = ttest_QZ(cellfun(@nanmean,CTWater_M),cellfun(@nanmean,CTBase_M),'Matrix CTS Water vs Base: ');
p2deval = ttest_QZ(cellfun(@nanmean,CTSucrose_M),cellfun(@nanmean,CTBase_M),'Matrix CTS Sucrose vs Base: ');
p3deval = ttest_QZ([cellfun(@nanmean,CTWater_M) cellfun(@nanmean,CTSucrose_M)],...
    [cellfun(@nanmean,CTBase_M) cellfun(@nanmean,CTBase_M)],'Matrix CTS Water&Sucrose vs Base: ');
p4deval = ttest_QZ(cellfun(@nanmean,RTWater_M),cellfun(@nanmean,RTBase_M),'Matrix RTS Water vs Base: ');
p5deval = ttest_QZ(cellfun(@nanmean,RTSucrose_M),cellfun(@nanmean,RTBase_M),'Matrix RTS Sucrose vs Base: ');
p6deval = ttest_QZ([cellfun(@nanmean,RTWater_M) cellfun(@nanmean,RTSucrose_M)],...
    [cellfun(@nanmean,RTBase_M) cellfun(@nanmean,RTBase_M)],'Matrix RTS Water&Sucrose vs Base: ');