function [tpr, fpr, dp, c] = dprime_and_c(trials,positive_stim,negative_stim)
    
    [t, f] = helper_roc(trials,positive_stim,negative_stim);

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

    
    function [tpr, fpr] = helper_roc(trials,positive_stim,negative_stim)
        lick_threshold = 1;
 
        num_hits = 0;
        num_pos_trials = 0;
 
        num_false_alarm = 0;
        num_neg_trials = 0;
        
        for i = 1:height(trials)
            trial = trials(i, :);
 
            % Check for True Positive
            if trial.StimulusID == positive_stim
                num_pos_trials = num_pos_trials + 1;
 
                if trial.ResponseLickFrequency >= lick_threshold
                    num_hits = num_hits + 1;
                end
            end
 
            % Check for False Positive
            if trial.StimulusID == negative_stim
                num_neg_trials = num_neg_trials + 1;
 
                if trial.ResponseLickFrequency >= lick_threshold
                    num_false_alarm = num_false_alarm + 1;
                end
            end
        end
        
        tpr = num_hits / num_pos_trials;
        fpr = num_false_alarm / num_neg_trials;
    end 
end