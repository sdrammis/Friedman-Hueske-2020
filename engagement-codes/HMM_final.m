function [engaged, not_engaged, unknown, Ts, Es, BICs, MPCs, converged] =...
    HMM_final(splitTrials,num_states,lick_threshold,transition_init,all_tones,rewardTone)

    %Do full battery of models
    %1. s3 and s2, 2 emissions (2 or 3 lick thresholds)
    %2. Greater window size
    %3. Different Initialization
    %For Unconverged
    %3. All trials
    %4. Add tone 2 trials
    
    %% User Params
    symbols = {'H', 'L'};    
    
    if num_states == 2
        set_T = [0.8, 0.2;
                 0.2, 0.8]; % [not engaged, engaged]
        set_E = [0.6, 0.4;
                 0.4, 0.6]; %[ low licks, high licks]
    elseif num_states == 3
        if transition_init == 1
            set_T = [0.7, 0.15, 0.15;
                     0.7, 0.15, 0.15;
                     0.7, 0.15, 0.15]; % [not engaged, engaged, unknown]
            set_E = [0.8, 0.2;
                     0.35, 0.65;
                     0.6 0.4]; %[ low licks, high licks]
        elseif transition_init == 2
            set_T = [0.8, 0.01, 0.19;
                    0.01, 0.09, 0.9;
                    0.15, 0.15, 0.7]; % [not engaged, engaged, unknown]
            set_E = [0.8, 0.2;
                    0.35, 0.65;
                    0.6 0.4]; %[ low licks, high licks]
        end
    end
    numWindows = length(splitTrials);
    
    engaged = [];
    not_engaged = [];
    unknown = [];
    BICs = zeros(1,numWindows);
    MPCs = zeros(1,numWindows);
    Ts = cell(1,numWindows);
    Es = cell(1,numWindows);
    converged = zeros(1,numWindows);
    for n = 1:numWindows
        training_set = splitTrials{n};
        if ~all_tones
            training_set = training_set([training_set.StimulusID] == rewardTone, :);
        end
        [Ts{n}, Es{n}, loglikes,converged(n)] = HMM_train(training_set, set_T, set_E, lick_threshold, symbols, false);
        if ~converged(n)
            break
        end
        [~, BICs(n)] = aicbic_final(loglikes(end), 15, size(training_set, 1)); 
        [ states ,~,p_states] = HMM_decode(training_set, Ts{n}, Es{n}, lick_threshold, symbols, false );
        MPCs(n) = calculate_mpc(p_states);
        if num_states == 2
            [eTrials, nTrials] = splitByStates2(splitTrials{n}, states,rewardTone);
        elseif num_states == 3
            [eTrials, nTrials, uTrials] = splitByStates3(splitTrials{n}, states,rewardTone);
            unknown = vertcat(unknown, uTrials);
        end
        engaged = vertcat(engaged, eTrials);
        not_engaged = vertcat(not_engaged, nTrials);
    end
end
