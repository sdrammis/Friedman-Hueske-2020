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
% correlations
plotCorrROC3_QZ({(CBase-CWater),(CBase-CSucrose)},{(RTSBase-RTSWater),(RTSBase-RTSSucrose)},...
    [strioStr ' Deval Difference in C'],'Diff. in C','Reward Trace Sum',...
    0,{'Base-Water','Base-Sucrose'},{'o','o'},{'b','r'},{'b','r'},0,mouseIDs,0,'');
end