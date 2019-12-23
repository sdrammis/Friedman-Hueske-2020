function [tpr, fpr, dp, c] = dprime_and_c_licks(reward_licks,cost_licks)
    
    [t, f] = helper_roc(reward_licks,cost_licks);

    clip_max = @(x) min([x 0.99]);
    clip_min = @(x) max([x 0.01]);
    clip = @(x) clip_max(clip_min(x));
    
    clipt = arrayfun(clip, t);
    clipf = arrayfun(clip, f);
    
    z_h = norminv(clipt);
    z_f = norminv(clipf);

    tpr = clipt;
    fpr = clipf;
    dp = z_h - z_f;
    c = -0.5 * (z_h + z_f);

    function [tpr, fpr] = helper_roc(reward_licks,cost_licks)
        lick_threshold = 1;
 
        num_hits = sum(reward_licks >= lick_threshold);
        num_pos_trials = length(reward_licks);
 
        num_false_alarm = sum(cost_licks >= lick_threshold);
        num_neg_trials = length(cost_licks);
        
        tpr = num_hits / num_pos_trials;
        fpr = num_false_alarm / num_neg_trials;
    end 
end