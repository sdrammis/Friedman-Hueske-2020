% Author: QZ
% 08/26/2019
function [nanIdxs,mouseIDs,CWater,CSucrose,CBase,DWater,DSucrose,DBase,...
    RTAWater,RTASucrose,RTABase,RTSWater,RTSSucrose,RTSBase,CTSWater,...
    CTSSucrose,CTSBase,RCTSWater,RCTSSucrose,RCTSBase] = calcAndPlotDevalUPDATE1_QZ(twdb,...
    mouseIDs,miceTrialData,miceFluorData,rTones,cTones,numSessions,strioStr,devalData)
CWater = zeros(1,length(mouseIDs));
CSucrose = zeros(1,length(mouseIDs));
CBase = zeros(1,length(mouseIDs));
DWater = zeros(1,length(mouseIDs));
DSucrose = zeros(1,length(mouseIDs));
DBase = zeros(1,length(mouseIDs));
RTAWater = zeros(1,length(mouseIDs));
RTASucrose = zeros(1,length(mouseIDs));
RTABase = zeros(1,length(mouseIDs));
RTSWater = zeros(1,length(mouseIDs));
RTSSucrose = zeros(1,length(mouseIDs));
RTSBase = zeros(1,length(mouseIDs));
CTSWater = zeros(1,length(mouseIDs));
CTSSucrose = zeros(1,length(mouseIDs));
CTSBase = zeros(1,length(mouseIDs));
RCTSWater = zeros(1,length(mouseIDs));
RCTSSucrose = zeros(1,length(mouseIDs));
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
    waterIdx = first(twdb_lookup(table2struct(devalData),'index',...
        'key','mouseID',msID,'key','devaluation','Water'));
    sucroseIdx = first(twdb_lookup(table2struct(devalData),'index',...
        'key','mouseID',msID,'key','devaluation','Sucrose'));
    baseIdx = first(twdb_lookup(twdb,'index','key','mouseID',msID,...
        'key','sessionNumber',numSession));
    waterTrialData = twdb(waterIdx).trialData;
    sucroseTrialData = twdb(sucroseIdx).trialData;
    baseTrialData = twdb(baseIdx).trialData;
    waterFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,waterIdx,waterTrialData);
    sucroseFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,sucroseIdx,sucroseTrialData);
    baseFluorData = getFluorTrialsFromIdx_QZ(twdb,msID,baseIdx,baseTrialData);
    [dpWater,rtaWater,rctsWater,rtsWater,ctsWater,cWater,~,~] = get_dprime_traceArea(waterTrialData,...
        waterFluorData,rTone,cTone);
    [dpSucrose,rtaSucrose,rctsSucrose,rtsSucrose,ctsSucrose,cSucrose,~,~] = get_dprime_traceArea(sucroseTrialData,...
        sucroseFluorData,rTone,cTone);
    [dpBase,rtaBase,rctsBase,rtsBase,ctsBase,cBase,~,~] = get_dprime_traceArea(baseTrialData,...
        baseFluorData,rTone,cTone);
    CWater(i) = cWater;
    CSucrose(i) = cSucrose;
    CBase(i) = cBase;
    DWater(i) = dpWater;
    DSucrose(i) = dpSucrose;
    DBase(i) = dpBase;
    RTAWater(i) = rtaWater;
    RTASucrose(i) = rtaSucrose;
    RTABase(i) = rtaBase;
    RTSWater(i) = rtsWater;
    RTSSucrose(i) = rtsSucrose;
    RTSBase(i) = rtsBase;
    CTSWater(i) = ctsWater;
    CTSSucrose(i) = ctsSucrose;
    CTSBase(i) = ctsBase;
    RCTSWater(i) = rctsWater;
    RCTSSucrose(i) = rctsSucrose;
    RCTSBase(i) = rctsBase;
    if sum(sum(~isnan(baseFluorData))) == 0 || ...
            sum(sum(~isnan(waterFluorData))) == 0 || ...
            sum(sum(~isnan(sucroseFluorData))) == 0
        nanIdxs = [nanIdxs i];
    end
end
disp(nanIdxs)
% clean data
CWater(nanIdxs) = [];
CSucrose(nanIdxs) = [];
CBase(nanIdxs) = [];
DWater(nanIdxs) = [];
DSucrose(nanIdxs) = [];
DBase(nanIdxs) = [];
RTAWater(nanIdxs) = [];
RTASucrose(nanIdxs) = [];
RTABase(nanIdxs) = [];
RTSWater(nanIdxs) = [];
RTSSucrose(nanIdxs) = [];
RTSBase(nanIdxs) = [];
CTSWater(nanIdxs) = [];
CTSSucrose(nanIdxs) = [];
CTSBase(nanIdxs) = [];
RCTSWater(nanIdxs) = [];
RCTSSucrose(nanIdxs) = [];
RCTSBase(nanIdxs) = [];
mouseIDs(nanIdxs) = [];
% plotting
figure()
subplot(1,2,1)
hold on
plotNoBar({(CBase-CSucrose),(CBase-CWater),(CWater-CSucrose),CSucrose,CWater,CBase},'C',...
    {'Base-Suc','Base-Water','Water-Sucrose','Sucrose','Water','Base'},['Deval C ' strioStr],...
    'r','k','r',1);
hold off
subplot(1,2,2)
hold on
plotNoBar({(DBase-DSucrose),(DBase-DWater),(DWater-DSucrose),DSucrose,DWater,DBase},'D-Prime',...
    {'Base-Suc','Base-Water','Water-Sucrose','Sucrose','Water','Base'},['Deval D-Prime ' strioStr],...
    'r','k','r',1);
hold off
% traces
figure()
subplot(2,2,1)
hold on
plotNoBar({RTSBase-RTSSucrose,RTSBase-RTSWater,RTSWater-RTSSucrose,RTSSucrose,RTSWater,RTSBase},...
    'Reward Trace Sum',{'Base-Suc','Base-Water','Water-Sucrose','Sucrose','Water','Base'},...
    ['Deval Reward Trace Sums' strioStr],'b','k','b',1);
hold off
subplot(2,2,2)
hold on
plotNoBar({CTSBase-CTSSucrose,CTSBase-CTSWater,CTSWater-CTSSucrose,CTSSucrose,CTSWater,CTSBase},...
    'Cost Trace Sum',{'Base-Suc','Base-Water','Water-Sucrose','Sucrose','Water','Base'},...
    ['Deval Cost Trace Sums' strioStr],'b','k','b',1);
hold off
subplot(2,2,3)
hold on
plotNoBar({RTABase-RTASucrose,RTABase-RTAWater,RTAWater-RTASucrose,RTASucrose,RTAWater,RTABase},...
    'R-C Trace Area',{'Base-Suc','Base-Water','Water-Sucrose','Sucrose','Water','Base'},...
    ['Deval R-C Trace Areas' strioStr],'b','k','b',1);
hold off
subplot(2,2,4)
hold on
plotNoBar({RCTSBase-RCTSSucrose,RCTSBase-RCTSWater,RCTSWater-RCTSSucrose,RCTSSucrose,RCTSWater,RCTSBase},...
    'R+C',{'Base-Suc','Base-Water','Water-Sucrose','Sucrose','Water','Base'},...
    ['Deval R+C' strioStr],'b','k','b',1);
hold off
% figure()
% subplot(1,3,1)
% hold on
% plotNoBar({RTAWater,RCTSWater,RTSWater,CTSWater},'Water Traces',...
%     {'RTA','RCTS','RTS','CTS'},['Deval Water ' strioStr],...
%     'b','k','b',1);
% hold off
% subplot(1,3,2)
% hold on
% plotNoBar({RTASucrose,RCTSSucrose,RTSSucrose,CTSSucrose},'Sucrose Traces',...
%     {'RTA','RCTS','RTS','CTS'},['Deval Sucrose ' strioStr],...
%     'b','k','b',1);
% hold off
% subplot(1,3,3)
% hold on
% plotNoBar({RTABase,RCTSBase,RTSBase,CTSBase},'Base Traces',...
%     {'RTA','RCTS','RTS','CTS'},['Deval Base ' strioStr],...
%     'b','k','b',1);
% hold off
% % Statistics
% disp(['>>>~~~------' strioStr '------~~~<<<'])
% disp('------------Tests for C------------')
% ttest_QZ(CWater,CSucrose,'C Water vs. Sucrose: ');
% ttest_QZ(CWater,CBase,'C Water vs. Base: ');
% ttest_QZ(CBase,CSucrose,'C Sucrose vs. Base: ');
% disp('------------Tests for DP------------')
% ttest_QZ(DWater,DSucrose,'DP Water vs. Sucrose: ');
% ttest_QZ(DWater,DBase,'DP Water vs. Base: ');
% ttest_QZ(DBase,DSucrose,'DP Sucrose vs. Base: ');
% disp('------------Tests for Traces------------')
% disp('~~~Different Trace within Same Treatment Group~~~')
% disp('>>>Water<<<')
% ttest_QZ(RTAWater,RCTSWater,'Water R-C vs. R+C: ');
% ttest_QZ(RTAWater,RTSWater,'Water R-C vs. R: ');
% ttest_QZ(RTAWater,CTSWater,'Water R-C vs. C: ');
% ttest_QZ(RCTSWater,RTSWater,'Water R+C vs. R: ');
% ttest_QZ(RCTSWater,CTSWater,'Water R+C vs. C: ');
% ttest_QZ(RTSWater,CTSWater,'Water R vs. C: ');
% disp('>>>Sucrose<<<')
% ttest_QZ(RTASucrose,RCTSSucrose,'Sucrose R-C vs. R+C: ');
% ttest_QZ(RTASucrose,RTSSucrose,'Sucrose R-C vs. R: ');
% ttest_QZ(RTASucrose,CTSSucrose,'Sucrose R-C vs. C: ');
% ttest_QZ(RCTSSucrose,RTSSucrose,'Sucrose R+C vs. R: ');
% ttest_QZ(RCTSSucrose,CTSSucrose,'Sucrose R+C vs. C: ');
% ttest_QZ(RTSSucrose,CTSSucrose,'Sucrose R vs. C: ');
% disp('>>>Base<<<')
% ttest_QZ(RTABase,RCTSBase,'Base R-C vs. R+C: ');
% ttest_QZ(RTABase,RTSBase,'Base R-C vs. R: ');
% ttest_QZ(RTABase,CTSBase,'Base R-C vs. C: ');
% ttest_QZ(RCTSBase,RTSBase,'Base R+C vs. R: ');
% ttest_QZ(RCTSBase,CTSBase,'Base R+C vs. C: ');
% ttest_QZ(RTSBase,CTSBase,'Base R vs. C: ');
% disp('~~~Same Trace Across Different Treatment Groups~~~')
% ttest_QZ(RTAWater,RTASucrose,'R-C Trace Water vs. Sucrose: ');
% ttest_QZ(RTAWater,RTABase,'R-C Trace Water vs. Base: ');
% ttest_QZ(RTABase,RTASucrose,'R-C Trace Sucrose vs. Base: ');
% ttest_QZ(RCTSWater,RCTSSucrose,'R+C Trace Water vs. Sucrose: ');
% ttest_QZ(RCTSWater,RCTSBase,'R+C Trace Water vs. Base: ');
% ttest_QZ(RCTSBase,RCTSSucrose,'R+C Trace Sucrose vs. Base: ');
% ttest_QZ(RTSWater,RTSSucrose,'Reward Trace Water vs. Sucrose: ');
% ttest_QZ(RTSWater,RTSBase,'Reward Trace Water vs. Base: ');
% ttest_QZ(RTSBase,RTSSucrose,'Reward Trace Sucrose vs. Base: ');
% ttest_QZ(CTSWater,CTSSucrose,'Cost Trace Water vs. Sucrose: ');
% ttest_QZ(CTSWater,CTSBase,'Cost Trace Water vs. Base: ');
% ttest_QZ(CTSBase,CTSSucrose,'Cost Trace Sucrose vs. Base: ');
% % correlations
% plotCorrROC3_QZ({CWater,CSucrose,CBase},{{RTAWater,RTASucrose,RTABase},...
%     {RCTSWater,RCTSSucrose,RCTSBase},{RTSWater,RTSSucrose,RTSBase},...
%     {CTSWater,CTSSucrose,CTSBase}},[strioStr ' Deval C'],{'C','C','C','C'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     1,{'Water','Sucrose','Base'},{'o','o','o'},{'b','r','g'},{'b','r','g'},...
%     0,mouseIDs,0,'');
% plotCorrROC3_QZ({DWater,DSucrose,DBase},{{RTAWater,RTASucrose,RTABase},...
%     {RCTSWater,RCTSSucrose,RCTSBase},{RTSWater,RTSSucrose,RTSBase},...
%     {CTSWater,CTSSucrose,CTSBase}},[strioStr ' Deval DP'],{'DP','DP','DP','DP'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     0,{'Water','Sucrose','Base'},{'o','o','o'},{'b','r','g'},{'b','r','g'},...
%     0,mouseIDs,0,'');
% plotCorrROC3_QZ({(CBase-CWater),(CBase-CSucrose)},{{(RTABase-RTAWater),(RTABase-RTASucrose)},...
%     {(RCTSBase-RCTSWater),(RCTSBase-RCTSSucrose)},{(RTSBase-RTSWater),(RTSBase-RTSSucrose)},...
%     {(CTSBase-CTSWater),(CTSBase-CTSSucrose)}},[strioStr ' Deval Difference in C'],...
%     {'Diff. in C','Diff. in C','Diff. in C','Diff. in C'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     1,{'Base-Water','Base-Sucrose'},{'o','o'},{'b','r'},{'b','r'},0,mouseIDs,0,'');
% plotCorrROC3_QZ({(DBase-DWater),(DBase-DSucrose)},{{(RTABase-RTAWater),(RTABase-RTASucrose)},...
%     {(RCTSBase-RCTSWater),(RCTSBase-RCTSSucrose)},{(RTSBase-RTSWater),(RTSBase-RTSSucrose)},...
%     {(CTSBase-CTSWater),(CTSBase-CTSSucrose)}},[strioStr ' Deval Difference in DP'],...
%     {'Diff. in DP','Diff. in DP','Diff. in DP','Diff. in DP'},...
%     {'R-C Trace Area','R+C Trace Sum','Reward Trace Sum','Cost Trace Sum'},...
%     0,{'Base-Water','Base-Sucrose'},{'o','o'},{'b','r'},{'b','r'},0,mouseIDs,0,'');
end