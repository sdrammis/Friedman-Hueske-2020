function [mice_rzscores,mice_czscores,mice_rtraces,...
    mice_ctraces] = calcZRespLicks_QZ(miceTrials,miceFTrials,rTones,cTones)
mice_rzscores = cell(1,length(miceTrials));
mice_czscores = cell(1,length(miceTrials));
mice_rtraces = cell(1,length(miceTrials));
mice_ctraces = cell(1,length(miceTrials));
% mice_rIdxs = cell(1,length(miceTrials));
% mice_cIdxs = cell(1,length(miceTrials));
for i = 1:length(miceTrials)
    rTone = rTones(i);
    cTone = cTones(i);
    mouseTrials = miceTrials{i};
    mouseFTrials = miceFTrials{i};
    [z,~,~] = calcZScore_QZ(mouseTrials.ResponseLickFrequency);
    responsePeriod = 39:46;
%     rIdxs = find(mouseTrials.StimulusID == rTone);
%     cIdxs = find(mouseTrials.StimulusID == cTone);
    rz = z(mouseTrials.StimulusID == rTone);
    cz = z(mouseTrials.StimulusID == cTone);
    mice_rzscores{i} = rz;
    mice_czscores{i} = cz;
%     mice_rIdxs{i} = rIdxs;
%     mice_cIdxs{i} = cIdxs;
    [~,~,rFTrials,cFTrials] = reward_and_cost_trials(mouseTrials,...
        mouseFTrials,rTone,cTone); % kind of redundant
    responseRewardTrace = rFTrials(:,responsePeriod);
    responseCostTrace = cFTrials(:,responsePeriod);
    respRTraceSum = nansum(responseRewardTrace,2);
    respCTraceSum = nansum(responseCostTrace,2);
    mice_rtraces{i} = respRTraceSum;
    mice_ctraces{i} = respCTraceSum;
end
end