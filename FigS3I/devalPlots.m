function devalPlots(twdb)
% Author: QZ
% 08/26/2019
% crossPlotsDZPDeval_UPDATE1.m
% deval part3, dzp part2
%% Part I. Deval Part 3 Update. No binning. Each Mouse is a data point.
% only learned WT
devalData = devalData_UPDATE1(twdb);
strioIDs = unique(twdb_lookup(table2struct(devalData),'mouseID',...
    'key','Health','WT','key','intendedStriosomality','Strio',...
    'grade','learnedFirstTask',0,inf));
upToLearned = 0;
reversal = 0;
[strioTrials,strioFTrials,strioRTones,strioCTones,strioN] = get_all_trials(twdb,...
    strioIDs,upToLearned,reversal);
[~,mouseIDsStrio,~,~,~,~,~,~,RTWater_S,RTSucrose_S,RTBase_S,CTWater_S,...
    CTSucrose_S,CTBase_S,nWater_S,nSucrose_S,nBase_S] = calcAndPlotDevalUPDATE2_QZ(twdb,...
    strioIDs,strioRTones,strioCTones,strioN,'Strio',devalData);
% statistics
p1 = ttest_QZ(cellfun(@nanmean,CTWater_S),cellfun(@nanmean,CTBase_S),'Strio CTS Water vs Base: ');
p2 = ttest_QZ(cellfun(@nanmean,CTSucrose_S),cellfun(@nanmean,CTBase_S),'Strio CTS Sucrose vs Base: ');
p3 = ttest_QZ([cellfun(@nanmean,CTWater_S) cellfun(@nanmean,CTSucrose_S)],...
    [cellfun(@nanmean,CTBase_S) cellfun(@nanmean,CTBase_S)],'Strio CTS Water&Sucrose vs Base: ');
p4 = ttest_QZ(cellfun(@nanmean,RTWater_S),cellfun(@nanmean,RTBase_S),'Strio RTS Water vs Base: ');
p5 = ttest_QZ(cellfun(@nanmean,RTSucrose_S),cellfun(@nanmean,RTBase_S),'Strio RTS Sucrose vs Base: ');
p6 = ttest_QZ([cellfun(@nanmean,RTWater_S) cellfun(@nanmean,RTSucrose_S)],...
    [cellfun(@nanmean,RTBase_S) cellfun(@nanmean,RTBase_S)],'Strio RTS Water&Sucrose vs Base: ');
