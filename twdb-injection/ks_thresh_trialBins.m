function [learned_trials,ks_p] = ks_thresh_trialBins(mouseTrials,thresh,...
    rolling_window,consecutiveBins,rewardTone,costTone,bin_size,learning_rolling_window)

thresh = thresh/100;
min_lick = 0;

learned_bin = [];

[ks_p, tone_above, bin_sizes] = mouseCDF_rolling_trialBins(mouseTrials,...
    rewardTone,costTone,min_lick,rolling_window,bin_size);

rolling_ks_p = [];
for n = 1:length(ks_p)-(learning_rolling_window-1)
    rolling_ks_p(n) = mean(ks_p(n:n+learning_rolling_window-1));
end

mouse_thresh = find(rolling_ks_p(2:end)<=thresh)+1;
if isempty(mouse_thresh)
%     if mean(ks_p(end-learning_rolling_window:end)) < thresh
%         mouse_thresh = length(ks_p)-learning_rolling_window;
%     end
    if ks_p(end) < thresh/2
        mouse_thresh = length(ks_p);
    end
end

if consecutiveBins > 1
    for c = 1:consecutiveBins-1
        mouse_thresh = mouse_thresh(diff(mouse_thresh)==1);
    end
end

mouse_thresh = mouse_thresh(tone_above(mouse_thresh) == costTone);

if ~isempty(mouse_thresh)
    learned_trials = sum(bin_sizes(1:mouse_thresh(1)));
else
    learned_trials = [];
end