% Author: QZ
% 08/29/2019
function [nanIdxs,mouseIDs,CWater,CSucrose,CBase,DWater,DSucrose,DBase,...
    RTWater,RTSucrose,RTBase,CTWater,CTSucrose,CTBase,nWaterTrials,...
    nSucroseTrials,nBaseTrials] = calcAndPlotDevalUPDATE2_QZ(twdb,...
    mouseIDs,rTones,cTones,numSessions,strioStr,devalData)
CWater = zeros(1,length(mouseIDs));
CSucrose = zeros(1,length(mouseIDs));
CBase = zeros(1,length(mouseIDs));
DWater = zeros(1,length(mouseIDs));
DSucrose = zeros(1,length(mouseIDs));
DBase = zeros(1,length(mouseIDs));
RTWater = cell(1,length(mouseIDs));
RTSucrose = cell(1,length(mouseIDs));
RTBase = cell(1,length(mouseIDs));
CTWater = cell(1,length(mouseIDs));
CTSucrose = cell(1,length(mouseIDs));
CTBase = cell(1,length(mouseIDs));
nanIdxs = [];
nWaterTrials = zeros(1,length(mouseIDs));
nSucroseTrials = zeros(1,length(mouseIDs));
nBaseTrials = zeros(1,length(mouseIDs));
for i = 1:length(mouseIDs)
    msID = mouseIDs{i};
    disp(['------' num2str(i) ': Mouse ' msID '------'])
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
    [dpWater,rTraceWater,cTraceWater,cWater,~,~] = get_dprime_traceArea_UPDATE2(waterTrialData,...
        waterFluorData,rTone,cTone);
    [dpSucrose,rTraceSucrose,cTraceSucrose,cSucrose,~,~] = get_dprime_traceArea_UPDATE2(sucroseTrialData,...
        sucroseFluorData,rTone,cTone);
    [dpBase,rTraceBase,cTraceBase,cBase,~,~] = get_dprime_traceArea_UPDATE2(baseTrialData,...
        baseFluorData,rTone,cTone);
    CWater(i) = cWater;
    CSucrose(i) = cSucrose;
    CBase(i) = cBase;
    DWater(i) = dpWater;
    DSucrose(i) = dpSucrose;
    DBase(i) = dpBase;
    RTWater{i} = rTraceWater;
    RTSucrose{i} = rTraceSucrose;
    RTBase{i} = rTraceBase;
    CTWater{i} = cTraceWater;
    CTSucrose{i} = cTraceSucrose;
    CTBase{i} = cTraceBase;
    nWaterTrials(i) = height(waterTrialData);
    nSucroseTrials(i) = height(sucroseTrialData);
    nBaseTrials(i) = height(baseTrialData);
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
RTWater(nanIdxs) = [];
RTSucrose(nanIdxs) = [];
RTBase(nanIdxs) = [];
CTWater(nanIdxs) = [];
CTSucrose(nanIdxs) = [];
CTBase(nanIdxs) = [];
mouseIDs(nanIdxs) = [];
nWaterTrials(nanIdxs) = [];
nSucroseTrials(nanIdxs) = [];
nBaseTrials(nanIdxs) = [];
figure() % Plot c
for i = 1:length(CWater)
    hold on
    plotNoBar_UPDATE2({CBase(i),CWater(i)},'C',{'Base','Deval'},strioStr,...
        'b','b','b',1,0)
    hold on
    plotNoBar_UPDATE2({CBase(i),CSucrose(i)},'C',{'Base','Deval'},strioStr,...
        'r','r','r',1,0)
    hold off
    hold off
end
end