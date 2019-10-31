function [mean_rz,mean_cz,RTS,CTS,DP] = calcZRespLicks4_QZ(mouseIDs,...
    miceTrials,miceFTrials,rTones,cTones,binSize,lowDP,highDP)
% clip by dp
mean_rz = [];
mean_cz = [];
RTS = [];
CTS = [];
DP = [];
for i = 1:length(mouseIDs)
%     disp(['------' num2str(i) ': ' mouseIDs{i} '------'])
    mouseTrials = miceTrials{i};
    mouseFTrials = miceFTrials{i};
    rTone = rTones(i);
    cTone = cTones(i);
    respLicks = mouseTrials.ResponseLickFrequency;
    thisMouseMean = nanmean(respLicks);
    thisMouseSD = nanstd(respLicks);
    binCuts = round(linspace(1,height(mouseTrials),ceil(height(mouseTrials)/binSize)));
    thisMouseRZ = [];
    thisMouseCZ = [];
    thisMouseRTS = [];
    thisMouseCTS = [];
    thisMouseDP = [];
    for j = 2:length(binCuts)
        startIdx = binCuts(j-1);
        if j == length(binCuts)
            endIdx = binCuts(j);
        else
            endIdx = binCuts(j)-1;
        end
        thisBinTrials = mouseTrials(startIdx:endIdx,:);
        thisBinFTrials = mouseFTrials(startIdx:endIdx,:);
        % separate reward and cost
        [dp,~,rts,cts,~,~,~] = get_dprime_traceArea(thisBinTrials,thisBinFTrials,rTone,cTone);
        if isnan(rts) || isnan(cts) || isnan(dp) || dp < lowDP || dp > highDP
            continue;
        end
        thisBinRTrials = thisBinTrials(thisBinTrials.StimulusID == rTone,:);
        thisBinCTrials = thisBinTrials(thisBinTrials.StimulusID == cTone,:);
        thisBinRZ = nanmean((thisBinRTrials.ResponseLickFrequency-thisMouseMean)/thisMouseSD);
        thisBinCZ = nanmean((thisBinCTrials.ResponseLickFrequency-thisMouseMean)/thisMouseSD);
        thisMouseRZ(end+1) = thisBinRZ;
        thisMouseCZ(end+1) = thisBinCZ;
        thisMouseRTS(end+1) = rts;
        thisMouseCTS(end+1) = cts;
        thisMouseDP(end+1) = dp;
    end
    mean_rz = [mean_rz thisMouseRZ];
    mean_cz = [mean_cz thisMouseCZ];
    RTS = [RTS thisMouseRTS];
    CTS = [CTS thisMouseCTS];
    DP = [DP thisMouseDP];
end
end