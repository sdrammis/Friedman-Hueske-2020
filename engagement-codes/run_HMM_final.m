function run_HMM_final(trialDataDB,mouseID,num_states,lick_threshold,window_size,transition_init,all_tones, outDir)
    id = randi(1000);
    
    if all_tones
        tone_str = 'all-tone-trials';
    else
        tone_str = 'reward-trials';
    end
    
    if isequal(window_size,'all')
        cout(id, sprintf(...
            'Running HMM %d states 2 emissions for mouseID=%s, window_size=%s, threshold=%d, initialization=%d and training on %s...', ...
            num_states, mouseID, [window_size ' trials'], lick_threshold,transition_init,tone_str));
    else
        cout(id, sprintf(...
            'Running HMM %d states 2 emissions for mouseID=%s, window_size=%d, threshold=%d, initialization=%d and training on %s...', ...
            num_states, mouseID, window_size, lick_threshold,transition_init,tone_str));
    end
    
    mouse_idx = find(cellfun(@(x)isequal(x,mouseID),{trialDataDB(:).mouseID}));
    mouseTrials = trialDataDB(mouse_idx).trialData;
    rewardTone = trialDataDB(mouse_idx).rewardTone;
    numTrials = height(mouseTrials);
    rewardTrials = mouseTrials(mouseTrials.StimulusID == rewardTone, :);
    numTrials_reward = height(rewardTrials);
    
    if isequal(window_size,'all')
        numWindows = 1;
    else
        if all_tones
            numWindows = max(round(numTrials/window_size), 1);
        else
            numWindows = max(round(numTrials_reward/window_size), 1);
        end
    end
    
    if numWindows == 1 && ~isequal(window_size,'all')
        cout(id, sprintf('Window size of %d is too big for %s with %s', window_size,mouseID,tone_str));
    else
        splitTrials = splitData(mouseTrials,numWindows);
    
        [engaged, notEngaged, unknown, Ts, Es, BICs, MPCs, converged] = ...
            HMM_final(splitTrials,num_states,lick_threshold,transition_init,all_tones,rewardTone);
        if sum(converged==false)
            cout(id, sprintf('Ungonverged HMM'));
        else
            trialsToSort = [];
            if ~isempty(engaged)
                 engaged = table2struct(engaged);
                 [engaged(:).Engagement] = deal(1);
                 trialsToSort = [trialsToSort; engaged];
            end    
            if ~isempty(notEngaged)
                 notEngaged = table2struct(notEngaged);
                 [notEngaged(:).Engagement] = deal(0);
                 trialsToSort = [trialsToSort; notEngaged];
            end
            if ~isempty(unknown)
                unknown = table2struct(unknown);
                [unknown(:).Engagement] = deal(-1);
                trialsToSort = [trialsToSort; unknown]; 
            end
            trials = nestedSortStruct(trialsToSort, {'SessionNumber', 'IDXofTrial'});

            cout(id, sprintf('Succesfully ran HMM.'));

        
            convergence_str = 'converged';
            if isequal(window_size,'all')
                outPath = sprintf('%s/%s-%s-%dstates-%swindowsize-%dthreshold-%dinit-%s.mat',...
                outDir,convergence_str,mouseID,num_states,[window_size '-trials-'],lick_threshold,transition_init,tone_str);
            else
                outPath = sprintf('%s/%s-%s-%dstates-%dwindowsize-%dthreshold-%dinit-%s.mat',...
                outDir,convergence_str,mouseID,num_states,window_size,lick_threshold,transition_init,tone_str);
            end
            save(outPath, 'trials', 'Ts', 'Es', 'BICs','MPCs','converged');
            cout(id, sprintf('Results saved at: %s.mat', outPath));
        end
    end
end