function stat = getStat(statType,mouseTrials,mouseFluorTrials,rewardTone,costTone)

[dPrime,responseTraceArea,responseRewardTraceSum,responseCostTraceSum,c]...
        = get_dprime_traceArea(mouseTrials,mouseFluorTrials,rewardTone,costTone);

if isequal(statType,'c')
    stat = c;
elseif isequal(statType,'dPrime')
    stat = dPrime;
elseif isequal(statType,'R-C')
    stat = responseTraceArea;
end
