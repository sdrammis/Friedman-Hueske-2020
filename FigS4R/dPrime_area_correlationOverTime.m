function [R,slope] = dPrime_area_correlationOverTime(twdb,miceIDs,reversal,engagement,learned)

R = {};
slope = {};
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,learned,reversal);
[~,miceEngagement] = miceTrialEngagement(miceTrials);
for m = 1:length(miceIDs)
    R_rolling = [];
    slope_rolling = [];
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    mouseEngagement = logical(miceEngagement{m});
    if ~isequal('all',engagement)
        if engagement == 1
            mouseTrials = mouseTrials(mouseEngagement,:);
            mouseFluorTrials = mouseFluorTrials(mouseEngagement,:);
        else
            mouseTrials = mouseTrials(~mouseEngagement,:);
            mouseFluorTrials = mouseFluorTrials(~mouseEngagement,:);
        end
    end

    numTrials = height(mouseTrials);
    bin_size = round(numTrials*0.05);
    start = 5*bin_size;
    for n = numTrials-start+1:-bin_size:1
        End = n+start-1;
        bin_dPrime = [];
        bin_responseTraceArea = [];
        mouseTrials_fromEnd = mouseTrials(n:End,:);
        mouseFluorTrials_fromEnd = mouseFluorTrials(n:End,:);
        numTrials_fromEnd = height(mouseTrials_fromEnd);
        for b = 1:bin_size:numTrials_fromEnd
            bin_range = b:b+bin_size-1;
            bin_fluorTrials = mouseFluorTrials_fromEnd(bin_range,:);
            bin_mouseTrials = mouseTrials_fromEnd(bin_range,:);
            [dPrime,responseTraceArea] = get_dprime_traceArea(bin_mouseTrials,bin_fluorTrials,rewardTone,costTone);
            if isnan(responseTraceArea)
                continue
            end
            bin_dPrime = [bin_dPrime dPrime];
            bin_responseTraceArea = [bin_responseTraceArea responseTraceArea];
        end
        cor1 = corr2(bin_dPrime,bin_responseTraceArea);
        R_rolling = [R_rolling cor1];
        [~,m1] = regression(bin_dPrime,bin_responseTraceArea);
        slope_rolling = [slope_rolling m1];
    end
    R = [R fliplr(R_rolling)];
    slope = [slope fliplr(slope_rolling)];
end