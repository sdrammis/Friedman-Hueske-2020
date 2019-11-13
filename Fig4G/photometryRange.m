function maxStrio = photometryRange(miceIDs,miceTrials,miceFluorTrials,rewardTones,costTones,engagement)

maxStrio = [];
for m = 1:length(miceTrials)
    
    mouseID = miceIDs{m};
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    
    engagedRange = mouseTrials.Engagement == engagement;
    if ~sum(engagedRange)
        return
    end

    mouseTrials = mouseTrials(engagedRange,:);
    mouseFluorTrials = mouseFluorTrials(engagedRange,:);

    numTrials = height(mouseTrials);
    numBins = 5;
    bin_size = round(numTrials/numBins);
    bins = fliplr(numTrials:-bin_size:0);
    if length(bins) < numBins + 1
        bins = [1 bins];
    end
    
    bin_dPrime = [];
    bin_responseTraceArea = [];
    bin_responseRewardTraceSum = [];
    bin_responseCostTraceSum = [];
    for b = 1:length(bins)-1
        bin_range = bins(b)+1:bins(b+1);
        bin_fluorTrials = mouseFluorTrials(bin_range,:);
        bin_mouseTrials = mouseTrials(bin_range,:);
        [dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum]...
            = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
        
        bin_dPrime = [bin_dPrime dPrime];
        bin_responseTraceArea = [bin_responseTraceArea responseTraceArea];
        bin_responseRewardTraceSum = [bin_responseRewardTraceSum responseRewardTraceSum];
        bin_responseCostTraceSum = [bin_responseCostTraceSum responseCostTraceSum];

    end

    if isempty(bin_responseTraceArea)
        return
    end    

    x = bin_dPrime;
    y = bin_responseTraceArea;
    area_R = corr2(x,y);
    y = bin_responseRewardTraceSum;
    reward_R = corr2(x,y);
    y = bin_responseCostTraceSum;
    cost_R = corr2(x,y);
    
    [~,I] = max(abs([area_R reward_R cost_R]));
    strioValues = {bin_responseTraceArea,bin_responseRewardTraceSum,bin_responseCostTraceSum};
    
    bestStrio = strioValues{I};
    
    maxStrio = [maxStrio range(bestStrio)];
    
    
end


