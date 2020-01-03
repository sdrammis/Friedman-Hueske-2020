% reward_licks, cost_licks are arrays of number of licks for reward and
% cost trials respectively
function [tpr, fpr, dp, c] = dprime_and_c_licks3(reward_licks,cost_licks)
    % calculate true and false positive rate from lick data arrays
    [t, f] = helper_roc(reward_licks,cost_licks);
    % clips data
    clip_max = @(x) min([x 0.99]);
    clip_min = @(x) max([x 0.01]);
    clip = @(x) clip_max(clip_min(x));
    
    clipt = arrayfun(clip, t);
    clipf = arrayfun(clip, f);
    z_h = norminv(clipt);
    z_f = norminv(clipf);

    tpr = clipt;
    fpr = clipf;
    % calculation of d-prime and c
    dp = z_h - z_f;
    c = -0.5 * (z_h + z_f);

    function [tpr, fpr] = helper_roc(reward_licks,cost_licks)
        % setting lick threshold
        lick_threshold = 3;
        % calculation number of trials the mouse licks at or above the
        % threshold for reward and cost trials respectively
        num_hits = sum(reward_licks >= lick_threshold);
        num_pos_trials = length(reward_licks);
        
        num_false_alarm = sum(cost_licks >= lick_threshold);
        num_neg_trials = length(cost_licks);
        % calculation of true positive rate (tpr) and false positive rate
        % (fpr)
        tpr = num_hits / num_pos_trials;
        fpr = num_false_alarm / num_neg_trials;
    end 
end