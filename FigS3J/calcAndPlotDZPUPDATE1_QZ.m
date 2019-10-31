% Author: QZ
% 08/26/2019
function [nanIdxs,mouseIDs,CSaline,CDZP,CBase,DSaline,DDZP,DBase,...
    RTASaline,RTADZP,RTABase,RTSSaline,RTSDZP,RTSBase,CTSSaline,...
    CTSDZP,CTSBase,RCTSSaline,RCTSDZP,RCTSBase] = calcAndPlotDZPUPDATE1_QZ(twdb,...
    mouseIDs,miceTrialData,miceFluorData,rTones,cTones,numSessions,strioStr,dzpData)
CSaline = zeros(1,length(mouseIDs));
CDZP = zeros(1,length(mouseIDs));
CBase = zeros(1,length(mouseIDs));
DSaline = zeros(1,length(mouseIDs));
DDZP = zeros(1,length(mouseIDs));
DBase = zeros(1,length(mouseIDs));
RTASaline = zeros(1,length(mouseIDs));
RTADZP = zeros(1,length(mouseIDs));
RTABase = zeros(1,length(mouseIDs));
RTSSaline = zeros(1,length(mouseIDs));
RTSDZP = zeros(1,length(mouseIDs));
RTSBase = zeros(1,length(mouseIDs));
CTSSaline = zeros(1,length(mouseIDs));
CTSDZP = zeros(1,length(mouseIDs));
CTSBase = zeros(1,length(mouseIDs));
RCTSSaline = zeros(1,length(mouseIDs));
RCTSDZP = zeros(1,length(mouseIDs));
RCTSBase = zeros(1,length(mouseIDs));
nanIdxs = [];
for i = 1:length(mouseIDs)
    msID = mouseIDs{i};
    disp(['------' num2str(i) ': Mouse ' msID '------'])
    trialData = miceTrialData{i};
    fluorData = miceFluorData{i};
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
    [dpBase,rtaBase,rctsBase,rtsBase,ctsBase,cBase,~,~] = get_dprime_traceArea(baseTrialData,...
        baseFluorData,rTone,cTone);
    CBase(i) = cBase;
    DBase(i) = dpBase;
    RTABase(i) = rtaBase;
    RCTSBase(i) = rctsBase;
    RTSBase(i) = rtsBase;
    CTSBase(i) = ctsBase;
    [dpDZP,rtaDZP,rctsDZP,rtsDZP,ctsDZP,cDZP,~,~] = get_dprime_traceArea(dzpTrialData,...
        dzpFluorData,rTone,cTone);
    CDZP(i) = cDZP;
    DDZP(i) = dpDZP;
    RTADZP(i) = rtaDZP;
    RCTSDZP(i) = rctsDZP;
    RTSDZP(i) = rtsDZP;
    CTSDZP(i) = ctsDZP;
    if length(salIdx) == 1
        disp('!')
        salineTrialData = twdb(salIdx).trialData;
        salineFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx,salineTrialData);
        [dpSaline,rtaSaline,rctsSaline,rtsSaline,ctsSaline,cSaline,~,~] = get_dprime_traceArea(salineTrialData,...
            salineFluorData,rTone,cTone);
    else
        salineBeforeTrialData = twdb(salIdx(1)).trialData;
        salineAfterTrialData = twdb(salIdx(2)).trialData;
        salineBeforeFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx(1),salineBeforeTrialData);
        salineAfterFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,salIdx(2),salineAfterTrialData);
        [dpSalineBefore,rtaSalineBefore,rctsSalineBefore,rtsSalineBefore,...
            ctsSalineBefore,cSalineBefore,~,~] = get_dprime_traceArea(salineBeforeTrialData,...
            salineBeforeFluorData,rTone,cTone);
        [dpSalineAfter,rtaSalineAfter,rctsSalineAfter,rtsSalineAfter,...
            ctsSalineAfter,cSalineAfter,~,~] = get_dprime_traceArea(salineAfterTrialData,...
            salineAfterFluorData,rTone,cTone);
        cSaline = nanmean([cSalineBefore,cSalineAfter]);
        dpSaline = nanmean([dpSalineBefore,dpSalineAfter]);
        rtaSaline = nanmean([rtaSalineBefore,rtaSalineAfter]);
        rtsSaline = nanmean([rtsSalineBefore,rtsSalineAfter]);
        ctsSaline = nanmean([ctsSalineBefore,ctsSalineAfter]);
        rctsSaline = nanmean([rctsSalineBefore,rctsSalineAfter]);
    end
    CSaline(i) = cSaline;
    DSaline(i) = dpSaline;
    RTASaline(i) = rtaSaline;
    RTSSaline(i) = rtsSaline;
    CTSSaline(i) = ctsSaline;
    RCTSSaline(i) = rctsSaline;
    if isnan(rtaSaline) || isnan(rtsSaline) || isnan(ctsSaline) || ...
            isnan(rctsSaline) || isnan(rtaDZP) || isnan(rtsDZP) || ...
            isnan(ctsDZP) || isnan(rctsDZP)
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
RTASaline(nanIdxs) = [];
RTADZP(nanIdxs) = [];
RTABase(nanIdxs) = [];
RTSSaline(nanIdxs) = [];
RTSDZP(nanIdxs) = [];
RTSBase(nanIdxs) = [];
CTSSaline(nanIdxs) = [];
CTSDZP(nanIdxs) = [];
CTSBase(nanIdxs) = [];
RCTSSaline(nanIdxs) = [];
RCTSDZP(nanIdxs) = [];
RCTSBase(nanIdxs) = [];
mouseIDs(nanIdxs) = [];
disp(['>>>~~~------' strioStr '------~~~<<<'])
disp('------------Tests for C------------')
ttest_QZ(CSaline,CDZP,'C Saline vs. DZP: ');
disp('------------Tests for DP------------')
ttest_QZ(DSaline,DDZP,'DP Saline vs. DZP: ');
disp('~~~Same Trace Across Different Treatment Groups~~~')
ttest_QZ(RTASaline,RTADZP,'R-C Trace Saline vs. DZP: ');
ttest_QZ(RCTSSaline,RCTSDZP,'R+C Trace Saline vs. DZP: ');
ttest_QZ(RTSSaline,RTSDZP,'Reward Trace Saline vs. DZP: ');
ttest_QZ(CTSSaline,CTSDZP,'Cost Trace Saline vs. DZP: ');
end