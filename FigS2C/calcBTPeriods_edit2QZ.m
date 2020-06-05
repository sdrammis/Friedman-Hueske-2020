function [bin_dp,bin_c,RLF,CLF] = calcBTPeriods_edit2QZ(mouseIDs,miceTrials,miceFTrials,rTones,cTones,numBins)
% edited for numBins rather than binSize
% mouse-by-mouse
% Author: QZ
% 08/16/2019

bin_dp = [];
bin_c = [];
RLF = [];
CLF = [];
for i = 1:length(mouseIDs)
    mouseTrials = miceTrials{i};
    mouseFTrials = miceFTrials{i};
    rTone = rTones(i);
    cTone = cTones(i);
    binCuts = round(linspace(1,height(mouseTrials),numBins));
    thisMouseDP = [];
    thisMouseC = [];
    thisMouseRLF = [];
    thisMouseCLF = [];
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
        [dp,~,~,~,c,~,~,rLickFreq,...
            cLickFreq] = get_dprime_traceArea_edit3QZ(thisBinTrials,thisBinFTrials,rTone,cTone);
        thisMouseDP(end+1) = dp;
        thisMouseC(end+1) = c;
        thisMouseRLF(end+1) = nanmean(rLickFreq); % mean lick freq for each bin
        thisMouseCLF(end+1) = nanmean(cLickFreq);
    end
    bin_dp = [bin_dp nanmean(thisMouseDP)];
    bin_c = [bin_c nanmean(thisMouseC)];
    RLF = [RLF nanmean(thisMouseRLF)];
    CLF = [CLF nanmean(thisMouseCLF)];
end
end