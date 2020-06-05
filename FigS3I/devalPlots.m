function devalPlots(twdb)

% Author: QZ
% 08/26/2019
% crossPlotsDZPDeval_UPDATE1.m
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
calcAndPlotDevalUPDATE1_QZ(twdb,strioIDs,strioTrials,...
    strioFTrials,strioRTones,strioCTones,strioN,'Strio',devalData);
[~,mouseIDsStrio,CWater_S,CSucrose_S,CBase_S,~,~,~,~,~,~,~,~,~,...
    nWater_S,nSucrose_S,nBase_S] = calcAndPlotDevalUPDATE2_QZ(twdb,...
    strioIDs,strioRTones,strioCTones,strioN,'Strio',devalData);
% statistics
p1 = ttest_QZ(CWater_S,CBase_S,'Strio C Water vs Base: ');
p2 = ttest_QZ(CSucrose_S,CBase_S,'Strio C Sucrose vs Base: ');
p3 = ttest_QZ([CWater_S CSucrose_S],[CBase_S CBase_S],'Strio C Water&Sucrose vs Base: ');
% table creation