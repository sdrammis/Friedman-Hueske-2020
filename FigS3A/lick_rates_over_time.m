function lick_rates_over_time(twdb,bin_size,miceIDs)

for mice_idx = 1:length(miceIDs)

    mouseID = miceIDs{mice_idx};
    mouseTrials = table;
    sessions_idx = get_mouse_sessions(twdb,mouseID,1,0,'all',0);
    
    for idx = sessions_idx
        trialData = twdb(idx).trialData;
        if ~isempty(trialData)
            mouseTrials = [mouseTrials; trialData];
        end
    end
    rewardTone = twdb(sessions_idx(1)).rewardTone;
    costTone = twdb(sessions_idx(1)).costTone;
    
    numTrials = height(mouseTrials);
    numBins = ceil(numTrials/bin_size);
    mean_rewardTone_licks_bin = [];
    mean_costTone_licks_bin = [];
    dp_bin = [];
    c_bin = [];
    for n = 1:numBins
        binStart = (n-1)*bin_size+1;
        binEnd = binStart+bin_size-1;
        if binEnd > numTrials
            binEnd = numTrials;
        end
        bin_trials = mouseTrials(binStart:binEnd,:);
        [~, ~, dp_bin(n), c_bin(n)] = dprime_and_c(bin_trials,rewardTone,costTone);
        rewardTone_trialsIDX = bin_trials.StimulusID == rewardTone;
        rewardTone_licks = bin_trials.ResponseLickFrequency(rewardTone_trialsIDX);
        costTone_trialsIDX = bin_trials.StimulusID == costTone;
        costTone_licks = bin_trials.ResponseLickFrequency(costTone_trialsIDX);
        mean_rewardTone_licks_bin(n) = mean(rewardTone_licks);
        mean_costTone_licks_bin(n) = mean(costTone_licks);
    end
    
    %%%%%Reversal
    mouseTrials = table;
    sessions_idx = get_mouse_sessions(twdb,mouseID,0,0,'all',0);
    for idx = sessions_idx
        trialData = twdb(idx).trialData;
        if ~isempty(trialData)
            mouseTrials = [mouseTrials; trialData];
        end
    end
    rewardTone = twdb(sessions_idx(1)).rewardTone;
    costTone = twdb(sessions_idx(1)).costTone;
    numTrials = height(mouseTrials);
    numBins_reversal = ceil(numTrials/bin_size);
    for i = 1:numBins_reversal
        binStart = (i-1)*bin_size+1;
        binEnd = binStart+bin_size-1;
        if binEnd > numTrials
            binEnd = numTrials;
        end
        n = i + numBins;
        bin_trials = mouseTrials(binStart:binEnd,:);
        [~, ~, dp_bin(n), c_bin(n)] = dprime_and_c(bin_trials,rewardTone,costTone);
        rewardTone_trialsIDX = bin_trials.StimulusID == rewardTone;
        rewardTone_licks = bin_trials.ResponseLickFrequency(rewardTone_trialsIDX);
        costTone_trialsIDX = bin_trials.StimulusID == costTone;
        costTone_licks = bin_trials.ResponseLickFrequency(costTone_trialsIDX);
        mean_rewardTone_licks_bin(n) = mean(rewardTone_licks);
        mean_costTone_licks_bin(n) = mean(costTone_licks);
    end

    figure
    subplot(2,1,1)
    hold on
    bar([mean_rewardTone_licks_bin',mean_costTone_licks_bin'])
    plot([numBins+0.5 numBins+0.5],[0 max([mean_costTone_licks_bin mean_rewardTone_licks_bin])],'k','LineWidth',3)
    xlabel(['Bins of ' num2str(bin_size) ' trials over Time'])
    ylabel('Mean Response Lick Frequency')
    xlim([0 numBins+numBins_reversal+1])
    ylim([0 max([mean_costTone_licks_bin mean_rewardTone_licks_bin])])
    legend('Reward Tone','Cost Tone','Start of Reversal')
    
    subplot(2,1,2)
    hold on
    bar([dp_bin', c_bin'])
    plot([numBins+0.5 numBins+0.5],[0 max([mean_costTone_licks_bin mean_rewardTone_licks_bin])],'k','LineWidth',3)
    xlabel(['Bins of ' num2str(bin_size) ' trials over Time'])
    ylabel('D-prime and C')
    xlim([0 numBins+numBins_reversal+1])
    ylim([min([dp_bin,0, c_bin]),max([dp_bin, c_bin])])
    legend('d prime','c','Start of Reversal')
    
    intended_strio_str = twdb(sessions_idx(1)).intendedStriosomality;
    health_str = twdb(sessions_idx(1)).Health;

    supertitle({[intended_strio_str ' ' health_str ':' mouseID]})
    
end
