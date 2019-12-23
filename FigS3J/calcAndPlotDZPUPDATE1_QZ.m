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
% % plotting
% figure()
% subplot(1,2,1)
% hold on
% plotNoBar({(CDZP-CBase),(CSaline-CBase),(CDZP-CSaline),CDZP,CSaline,CBase},'C',...
%     {'DZP-Base','Saline-Base','DZP-Saline','DZP','Saline','Base'},['DZP C' strioStr],...
%     'r','k','r',1);
% hold off
% subplot(1,2,2)
% hold on
% plotNoBar({(DDZP-DBase),(DSaline-DBase),(DDZP-DSaline),DDZP,DSaline,DBase},'D-Prime',...
%     {'DZP-Base','Saline-Base','DZP-Saline','DZP','Saline','Base'},['DZP D-Prime' strioStr],...
%     'r','k','r',1);
% hold off
% % traces
% figure()
% subplot(2,2,1)
% hold on
% plotNoBar({RTSDZP-RTSSaline,RTSSaline-RTSBase,RTSDZP-RTSBase,RTSSaline,RTSDZP,RTSBase},...
%     'Reward Trace Sum',{'DZP-Saline','Saline-Base','DZP-Base','Saline','DZP','Base'},...
%     ['DZP Reward Trace Sums' strioStr],'b','k','b',1);
% hold off
% subplot(2,2,2)
% hold on
% plotNoBar({CTSDZP-CTSSaline,CTSSaline-CTSBase,CTSDZP-CTSBase,CTSSaline,CTSDZP,CTSBase},...
%     'Cost Trace Sum',{'DZP-Saline','Saline-Base','DZP-Base','Saline','DZP','Base'},...
%     ['DZP Cost Trace Sums' strioStr],'b','k','b',1);
% hold off
% subplot(2,2,3)
% hold on
% plotNoBar({RTADZP-RTASaline,RTASaline-RTABase,RTADZP-RTABase,RTASaline,RTADZP,RTABase},...
%     'R-C Trace Area',{'DZP-Saline','Saline-Base','DZP-Base','Saline','DZP','Base'},...
%     ['DZP R-C Trace Areas' strioStr],'b','k','b',1);
% hold off
% subplot(2,2,4)
% hold on
% plotNoBar({RCTSDZP-RCTSSaline,RCTSSaline-RCTSBase,RCTSDZP-RCTSBase,RCTSSaline,RCTSDZP,RCTSBase},...
%     'R+C',{'DZP-Saline','Saline-Base','DZP-Base','Saline','DZP','Base'},...
%     ['DZP R+C' strioStr],'b','k','b',1);
% hold off
% figure()
% subplot(1,3,1)
% hold on
% plotNoBar({RTADZP,RCTSDZP,RTSDZP,CTSDZP},'DZP Traces',...
%     {'RTA','RCTS','RTS','CTS'},['DZP ' strioStr],...
%     'b','k','b',1);
% hold off
% subplot(1,3,2)
% hold on
% plotNoBar({RTASaline,RCTSSaline,RTSSaline,CTSSaline},'Saline Traces',...
%     {'RTA','RCTS','RTS','CTS'},['Saline ' strioStr],...
%     'b','k','b',1);
% hold off
% subplot(1,3,3)
% hold on
% plotNoBar({RTABase,RCTSBase,RTSBase,CTSBase},'Base Traces',...
%     {'RTA','RCTS','RTS','CTS'},['Deval Base ' strioStr],...
%     'b','k','b',1);
% hold off
% % Statistics
disp(['>>>~~~------' strioStr '------~~~<<<'])
disp('------------Tests for C------------')
ttest_QZ(CSaline,CDZP,'C Saline vs. DZP: ');
% ttest_QZ(CSaline,CBase,'C Saline vs. Base: ');
% ttest_QZ(CBase,CDZP,'C DZP vs. Base: ');
disp('------------Tests for DP------------')
ttest_QZ(DSaline,DDZP,'DP Saline vs. DZP: ');
% ttest_QZ(DSaline,DBase,'DP Saline vs. Base: ');
% ttest_QZ(DBase,DDZP,'DP DZP vs. Base: ');
% disp('------------Tests for Traces------------')
% disp('~~~Different Trace within Same Treatment Group~~~')
% disp('>>>Saline<<<')
% ttest_QZ(RTASaline,RCTSSaline,'Saline R-C vs. R+C: ');
% ttest_QZ(RTASaline,RTSSaline,'Saline R-C vs. R: ');
% ttest_QZ(RTASaline,CTSSaline,'Saline R-C vs. C: ');
% ttest_QZ(RCTSSaline,RTSSaline,'Saline R+C vs. R: ');
% ttest_QZ(RCTSSaline,CTSSaline,'Saline R+C vs. C: ');
% ttest_QZ(RTSSaline,CTSSaline,'Saline R vs. C: ');
% disp('>>>DZP<<<')
% ttest_QZ(RTADZP,RCTSDZP,'DZP R-C vs. R+C: ');
% ttest_QZ(RTADZP,RTSDZP,'DZP R-C vs. R: ');
% ttest_QZ(RTADZP,CTSDZP,'DZP R-C vs. C: ');
% ttest_QZ(RCTSDZP,RTSDZP,'DZP R+C vs. R: ');
% ttest_QZ(RCTSDZP,CTSDZP,'DZP R+C vs. C: ');
% ttest_QZ(RTSDZP,CTSDZP,'DZP R vs. C: ');
% disp('>>>Base<<<')
% ttest_QZ(RTABase,RCTSBase,'Base R-C vs. R+C: ');
% ttest_QZ(RTABase,RTSBase,'Base R-C vs. R: ');
% ttest_QZ(RTABase,CTSBase,'Base R-C vs. C: ');
% ttest_QZ(RCTSBase,RTSBase,'Base R+C vs. R: ');
% ttest_QZ(RCTSBase,CTSBase,'Base R+C vs. C: ');
% ttest_QZ(RTSBase,CTSBase,'Base R vs. C: ');
disp('~~~Same Trace Across Different Treatment Groups~~~')
ttest_QZ(RTASaline,RTADZP,'R-C Trace Saline vs. DZP: ');
% ttest_QZ(RTASaline,RTABase,'R-C Trace Saline vs. Base: ');
% ttest_QZ(RTABase,RTADZP,'R-C Trace DZP vs. Base: ');
ttest_QZ(RCTSSaline,RCTSDZP,'R+C Trace Saline vs. DZP: ');
% ttest_QZ(RCTSSaline,RCTSBase,'R+C Trace Saline vs. Base: ');
% ttest_QZ(RCTSBase,RCTSDZP,'R+C Trace DZP vs. Base: ');
ttest_QZ(RTSSaline,RTSDZP,'Reward Trace Saline vs. DZP: ');
% ttest_QZ(RTSSaline,RTSBase,'Reward Trace Saline vs. Base: ');
% ttest_QZ(RTSBase,RTSDZP,'Reward Trace DZP vs. Base: ');
ttest_QZ(CTSSaline,CTSDZP,'Cost Trace Saline vs. DZP: ');
% ttest_QZ(CTSSaline,CTSBase,'Cost Trace Saline vs. Base: ');
% ttest_QZ(CTSBase,CTSDZP,'Cost Trace DZP vs. Base: ');
% % correlations
% plotCorrROC3_QZ({CSaline,CDZP,CBase},{{RTASaline,RTADZP,RTABase},...
%     {RCTSSaline,RCTSDZP,RCTSBase},{RTSSaline,RTSDZP,RTSBase},...
%     {CTSSaline,CTSDZP,CTSBase}},[strioStr ' DZP C'],{'C','C','C','C'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     1,{'Saline','DZP','Base'},{'o','o','o'},{'b','r','g'},{'b','r','g'},...
%     0,mouseIDs,0,'');
% plotCorrROC3_QZ({DSaline,DDZP,DBase},{{RTASaline,RTADZP,RTABase},...
%     {RCTSSaline,RCTSDZP,RCTSBase},{RTSSaline,RTSDZP,RTSBase},...
%     {CTSSaline,CTSDZP,CTSBase}},[strioStr ' DZP DP'],{'DP','DP','DP','DP'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     0,{'Saline','DZP','Base'},{'o','o','o'},{'b','r','g'},{'b','r','g'},...
%     0,mouseIDs,0,'');
% plotCorrROC3_QZ({(CSaline-CBase),(CDZP-CBase)},{{(RTASaline-RTABase),(RTADZP-RTABase)},...
%     {(RCTSSaline-RCTSBase),(RCTSDZP-RCTSBase)},{(RTSSaline-RTSBase),(RTSDZP-RTSBase)},...
%     {(CTSSaline-CTSBase),(CTSDZP-CTSBase)}},[strioStr ' DZP Difference in C'],...
%     {'Diff. in C','Diff. in C','Diff. in C','Diff. in C'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     1,{'Saline-Base','DZP-Base'},{'o','o'},{'b','r'},{'b','r'},0,mouseIDs,0,'');
% plotCorrROC3_QZ({(DSaline-DBase),(DDZP-DBase)},{{(RTASaline-RTABase),(RTSDZP-RTABase)},...
%     {(RCTSSaline-RCTSBase),(RCTSDZP-RCTSBase)},{(RTSSaline-RTSBase),(RTSDZP-RTSBase)},...
%     {(CTSSaline-CTSBase),(CTSDZP-CTSBase)}},[strioStr ' DZP Difference in DP'],...
%     {'Diff. in DP','Diff. in DP','Diff. in DP','Diff. in DP'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     0,{'Saline-Base','DZP-Base'},{'o','o'},{'b','r'},{'b','r'},0,mouseIDs,0,'');
end