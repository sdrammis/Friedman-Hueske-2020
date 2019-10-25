% Author: QZ
% 08/01/2019
function [rTrace0,rTrace1,rTrace2,rTrace3,cTrace0,cTrace1,cTrace2,...
    cTrace3] = getTraceLevels_QZ(twdb,mouseIDs)
% gets the traces at different levels for the mice you want
rTrace0 = zeros(1,length(mouseIDs));
rTrace1 = zeros(1,length(mouseIDs));
rTrace2 = zeros(1,length(mouseIDs));
rTrace3 = zeros(1,length(mouseIDs));
cTrace0 = zeros(1,length(mouseIDs));
cTrace1 = zeros(1,length(mouseIDs));
cTrace2 = zeros(1,length(mouseIDs));
cTrace3 = zeros(1,length(mouseIDs));
for i = 1:length(mouseIDs)
    disp(['------' num2str(i) ': Mouse ' mouseIDs{i} '------'])
    msID = mouseIDs(i);
    if isa(twdb,'table')
        % assumes only tables are for deval and DZP
        mouseData = getMouseData_QZ(table2struct(twdb),msID);
        rTone = mouseData.rewardTone(1);
        cTone = mouseData.costTone(1);
        mouseTrials = table;
        mouseFluorTrials = table;
        for j = 1:height(mouseData)
            disp(['~~~' num2str(j) '~~~'])
            mouseTrials = [mouseTrials; mouseData.trialData{j}];
            mouseFluorTrials = [mouseFluorTrials; mouseData.fluorData{j}];
        end
    else
       mouseData = getMouseData_QZ(twdb,msID);
       sortedData = sortMouseData_QZ(mouseData);
       idxs = sortedData.index(strcmp(sortedData.taskType,sortedData.firstSessionType));
       [mouseTrials,mouseFluorTrials,rTone,cTone,~] = get_all_trials(twdb,msID,idxs);
    end
    [rTrials,cTrials,rFTrials,cFTrials] = reward_and_cost_trials(mouseTrials,mouseFluorTrials,rTone,cTone);
    rLicks = rTrials.ResponseLickFrequency(rTrials.ResponseLickFrequency > 0);
    rIdxs = find(rTrials.ResponseLickFrequency > 0); % idxs from rTrials
    cLicks = cTrials.ResponseLickFrequency(cTrials.ResponseLickFrequency > 0);
    cIdxs = find(cTrials.ResponseLickFrequency > 0); % idxs from cTrials
    topTenCutOffVal_R = prctile(rLicks,90);
    topTenCutOffVal_C = prctile(cLicks,90);
    rLicks = rLicks(rLicks <= topTenCutOffVal_R);
    rIdxs = rIdxs(rLicks <= topTenCutOffVal_R);
    cLicks = cLicks(cLicks <= topTenCutOffVal_C);
    cIdxs = cIdxs(cLicks <= topTenCutOffVal_C);
    rLevel0 = find(rTrials.ResponseLickFrequency == 0);
    rLevel1 = rIdxs(rLicks <= prctile(rLicks,37.5));
    rLevel2 = rIdxs(rLicks <= prctile(rLicks,75) & rLicks > prctile(rLicks,37.5));
    rLevel3 = rIdxs(rLicks > prctile(rLicks,75));
    cLevel0 = find(cTrials.ResponseLickFrequency == 0);
    cLevel1 = cIdxs(cLicks <= prctile(cLicks,37.5));
    cLevel2 = cIdxs(cLicks <= prctile(cLicks,75) & cLicks > prctile(cLicks,37.5));
    cLevel3 = cIdxs(cLicks > prctile(cLicks,75));
    [~,~,~,rTS0,~,~,~,~,~,~] = get_dprime_traceArea(rTrials(rLevel0,:),...
        rFTrials(rLevel0,:),rTone,cTone,1);
    [~,~,~,rTS1,~,~,~,~,~,~] = get_dprime_traceArea(rTrials(rLevel1,:),...
        rFTrials(rLevel1,:),rTone,cTone,1);
    [~,~,~,rTS2,~,~,~,~,~,~] = get_dprime_traceArea(rTrials(rLevel2,:),...
        rFTrials(rLevel2,:),rTone,cTone,1);
    [~,~,~,rTS3,~,~,~,~,~,~] = get_dprime_traceArea(rTrials(rLevel3,:),...
        rFTrials(rLevel3,:),rTone,cTone,1);
    [~,~,~,~,cTS0,~,~,~,~,~] = get_dprime_traceArea(cTrials(cLevel0,:),...
        cFTrials(cLevel0,:),rTone,cTone,1);
    [~,~,~,~,cTS1,~,~,~,~,~] = get_dprime_traceArea(cTrials(cLevel1,:),...
        cFTrials(cLevel1,:),rTone,cTone,1);
    [~,~,~,~,cTS2,~,~,~,~,~] = get_dprime_traceArea(cTrials(cLevel2,:),...
        cFTrials(cLevel2,:),rTone,cTone,1);
    [~,~,~,~,cTS3,~,~,~,~,~] = get_dprime_traceArea(cTrials(cLevel3,:),...
        cFTrials(cLevel3,:),rTone,cTone,1);
    rTrace0(i) = rTS0;
    rTrace1(i) = rTS1;
    rTrace2(i) = rTS2;
    rTrace3(i) = rTS3;
    cTrace0(i) = cTS0;
    cTrace1(i) = cTS1;
    cTrace2(i) = cTS2;
    cTrace3(i) = cTS3;
end
end