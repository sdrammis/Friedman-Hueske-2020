function [ks_p, tone_above, bin_sizes] = mouseCDF_rolling_trialBins(mouseTrials,rewardTone,costTone,min_lick,rolling_window,bin_size)

engaged = 0;
numTrials = height(mouseTrials);
numBins = ceil(numTrials/bin_size);
bin_trials = cell(1,numBins);
bin_sizes = [];
for n = numBins:-1:1
    binEnd = numTrials-(numBins-n)*bin_size;
    if n == 1
        binStart = 1;
    else
        binStart = binEnd-bin_size+1;
    end
    bin_trials{n} = mouseTrials(binStart:binEnd,:);
    bin_sizes(n) = height(bin_trials{n});
end

ks_p = nan(1,numBins-(rolling_window-1));
for bin = 1:numBins-(rolling_window-1)
    trialData = bin_trials{bin};
    for n = 1:(rolling_window-1)
        trialData_toAdd = bin_trials{bin+n};
        trialData = [trialData;trialData_toAdd];
    end
    
    [reward_cdf,reward_licks] = toneCDF(trialData,rewardTone,engaged,min_lick);
    [cost_cdf,cost_licks] = toneCDF(trialData,costTone,engaged,min_lick);
    if ~isempty(cost_licks) && ~isempty(reward_licks)
        [~,ks_p(bin)] = kstest2_learning(reward_licks,cost_licks,'Tail','smaller');
    end
    
%     figure
%     hold on
%     plot(min_lick:length(tone1_cdf)-1,tone1_cdf)
%     plot(min_lick:length(tone2_cdf)-1,tone2_cdf)
%     title({['ks: ',num2str(ks_p(bin))],['Max Dist at lick ',num2str(dist_lick),': ',num2str(dist)]})
%     ylim([0,1])
%     legend('Tone 1','Tone 2')
%     close
    
    if mean(reward_cdf-cost_cdf) < 0
        tone_above(bin) = costTone;
    else
        tone_above(bin) = rewardTone;
    end
end