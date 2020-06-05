% Author: QZ
% 08/29/2019
function [nanIdxs,mouseIDs,CSaline,CDZP,CBase,DSaline,DDZP,DBase,...
    RTSaline,RTDZP,RTBase,CTSaline,CTDZP,CTBase,nSaline,nDZP,...
    nBase,RTDZPSE,RTSalineSE,CTDZPSE,CTSalineSE] = calcAndPlotDZPUPDATE2_QZ(twdb,...
    mouseIDs,rTones,cTones,numSessions,strioStr,dzpData)
CSaline = zeros(1,length(mouseIDs));
CDZP = zeros(1,length(mouseIDs));
CBase = zeros(1,length(mouseIDs));
DSaline = zeros(1,length(mouseIDs));
DDZP = zeros(1,length(mouseIDs));
DBase = zeros(1,length(mouseIDs));
RTSaline = cell(1,length(mouseIDs));
RTDZP = cell(1,length(mouseIDs));
RTBase = cell(1,length(mouseIDs));
CTSaline = cell(1,length(mouseIDs));
CTDZP = cell(1,length(mouseIDs));
CTBase = cell(1,length(mouseIDs));
nanIdxs = [];
nSaline = zeros(1,length(mouseIDs));
nDZP = zeros(1,length(mouseIDs));
nBase = zeros(1,length(mouseIDs));
RTDZPSE = zeros(1,length(mouseIDs));
RTSalineSE = zeros(1,length(mouseIDs));
CTDZPSE = zeros(1,length(mouseIDs));
CTSalineSE = zeros(1,length(mouseIDs));
for i = 1:length(mouseIDs)
    msID = mouseIDs{i};
    disp(['------' num2str(i) ': Mouse ' msID '------']);
    numSession = numSessions(i);
    rTone = rTones(i);
    cTone = cTones(i);
    dzpIdx = first(twdb_lookup(table2struct(dzpData),'index',...
        'key','mouseID',msID,'key','injection','Diazepam'));
    salIdx = cell2mat(twdb_lookup(table2struct(dzpData),'index',...
        'key','mouseID',msID,'key','injection','Saline'));
    baseIdx = first(twdb_lookup(twdb,'index','key','mouseID',msID,...
        'key','sessionNumber',numSession));
    dzpTrialData = twdb(dzpIdx).trialData;
    baseTrialData = twdb(baseIdx).trialData;
    dzpFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,dzpIdx,dzpTrialData);
    baseFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,baseIdx,baseTrialData);
    [dpBase,rTraceBase,cTraceBase,cBase,~,~] = get_dprime_traceArea_UPDATE2(baseTrialData,...
        baseFluorData,rTone,cTone);
    nDZP(i) = height(dzpTrialData);
    nBase(i) = height(baseTrialData);
    CBase(i) = cBase;
    DBase(i) = dpBase;
    RTBase{i} = rTraceBase;
    CTBase{i} = cTraceBase;
    [dpDZP,rTraceDZP,cTraceDZP,cDZP,~,~] = get_dprime_traceArea_UPDATE2(dzpTrialData,...
        dzpFluorData,rTone,cTone);
    CDZP(i) = cDZP;
    DDZP(i) = dpDZP;
    RTDZP{i} = rTraceDZP;
    CTDZP{i} = cTraceDZP;
    RTDZPSE(i) = calcSE(rTraceDZP);
    CTDZPSE(i) = calcSE(cTraceDZP);
    if length(salIdx) == 1
        disp('!')
        salineTrialData = twdb(salIdx).trialData;
        salineFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx,salineTrialData);
        [dpSaline,rtSaline,ctSaline,cSaline,~,~] = get_dprime_traceArea_UPDATE2(salineTrialData,...
            salineFluorData,rTone,cTone);
        nSaline(i) = height(salineTrialData);
        RTSalineSE(i) = calcSE(rtSaline);
        CTSalineSE(i) = calcSE(ctSaline);
    else
        salineBeforeTrialData = twdb(salIdx(1)).trialData;
        salineAfterTrialData = twdb(salIdx(2)).trialData;
        salineBeforeFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx(1),salineBeforeTrialData);
        salineAfterFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx(2),salineAfterTrialData);
        [dpSalineBefore,rTraceSalineBefore,cTraceSalineBefore,cSalineBefore,...
            ~,~] = get_dprime_traceArea_UPDATE2(salineBeforeTrialData,...
            salineBeforeFluorData,rTone,cTone);
        [dpSalineAfter,rTraceSalineAfter,cTraceSalineAfter,cSalineAfter,...
            ~,~] = get_dprime_traceArea_UPDATE2(salineAfterTrialData,...
            salineAfterFluorData,rTone,cTone);
        cSaline = nanmean([cSalineBefore,cSalineAfter]);
        dpSaline = nanmean([dpSalineBefore,dpSalineAfter]);
        rtSaline = nanmean([rTraceSalineBefore',rTraceSalineAfter']);
        ctSaline = nanmean([cTraceSalineBefore',cTraceSalineAfter']);
        nSaline(i) = height(salineBeforeTrialData) + height(salineAfterTrialData);
        RTSalineSE(i) = calcSE([rTraceSalineBefore' rTraceSalineAfter']);
        CTSalineSE(i) = calcSE([cTraceSalineBefore' cTraceSalineAfter']);
    end
    CSaline(i) = cSaline;
    DSaline(i) = dpSaline;
    RTSaline{i} = rtSaline;
    CTSaline{i} = ctSaline;
    if isnan(nanmean(rtSaline)) || isnan(nanmean(ctSaline)) || ...
            isnan(nanmean(rTraceBase)) || isnan(nanmean(cTraceBase)) || ...
            isnan(nanmean(rTraceDZP)) || isnan(nanmean(cTraceDZP))
        nanIdxs = [nanIdxs i];
    end
end
disp(nanIdxs);
% clean data
CSaline(nanIdxs) = [];
CDZP(nanIdxs) = [];
CBase(nanIdxs) = [];
DSaline(nanIdxs) = [];
DDZP(nanIdxs) = [];
DBase(nanIdxs) = [];
RTSaline(nanIdxs) = [];
RTDZP(nanIdxs) = [];
RTBase(nanIdxs) = [];
CTSaline(nanIdxs) = [];
CTDZP(nanIdxs) = [];
CTBase(nanIdxs) = [];
mouseIDs(nanIdxs) = [];
nSaline(nanIdxs) = [];
nDZP(nanIdxs) = [];
nBase(nanIdxs) = [];
RTDZPSE(nanIdxs) = [];
CTDZPSE(nanIdxs) = [];
RTSalineSE(nanIdxs) = [];
CTSalineSE(nanIdxs) = [];
figure() % Plot rts and cts
subplot(1,2,1)
for i = 1:length(RTDZP)
    hold on
    plotNoBar_UPDATE2({RTSaline{i},RTDZP{i}},'Reward Trace',{'Saline','DZP'},...
        strioStr,'b','b','b',0,0)
    hold off
end
subplot(1,2,2)
for i = 1:length(CTDZP)
    hold on
    plotNoBar_UPDATE2({CTSaline{i},CTDZP{i}},'Cost Trace',{'Saline','DZP'},...
        strioStr,'b','b','b',0,0)
    hold off
end
end