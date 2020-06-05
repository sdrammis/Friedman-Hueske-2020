function [tpr, fpr, dp, c] = roc_analysis_trials_JF(trials, reward_tone, cost_tone)
    
    [t, f] = helper_roc(trials, reward_tone, cost_tone);

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

    function [tpr, fpr] = helper_roc(trials, reward_tone, cost_tone)
        lick_threshold = 1;

%         positive_trial_licks = trials{trials.StimulusID == reward_tone, 'LicksInOutcome'};
%         negative_trial_licks = trials{trials.StimulusID == cost_tone, 'LicksInOutcome'};
        
        positive_trial_licks = trials{trials.StimulusID == reward_tone, 'ResponseLickFrequency'};
        negative_trial_licks = trials{trials.StimulusID == cost_tone, 'ResponseLickFrequency'};
 
        num_hits = sum(positive_trial_licks >= lick_threshold);
        num_pos_trials = length(positive_trial_licks);
 
        num_false_alarm = sum(negative_trial_licks >= lick_threshold);
        num_neg_trials = length(negative_trial_licks);
        
        tpr = num_hits / num_pos_trials;
        fpr = num_false_alarm / num_neg_trials;
    end 
end