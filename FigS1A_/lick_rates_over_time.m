function lick_rates_over_time(twdb,bin_size,miceIDs,pdf_bins,save)

if isempty(miceIDs)
    miceIDs = get_mouse_ids(twdb,0,'all','all','all','all','all','all',{});
end
for mice_idx = 1:length(miceIDs)
    if ~isempty(pdf_bins)
        mouse_pdf_bins = pdf_bins{mice_idx};
    end
    
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
    
    learning_trials = twdb(sessions_idx(1)).learnedFirstTask;
    if learning_trials ~= -1
        learning_bins = 0;
        learning_str = 'learned_';
    else
        learning_bins = -1;
        learning_str = '';
    end
    
    pdf_bins_trials = table;
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
        if ~isempty(pdf_bins) && sum(n==mouse_pdf_bins)
            pdf_bins_trials = [pdf_bins_trials; bin_trials];
        end
        [~, ~, dp_bin(n), c_bin(n)] = dprime_and_c(bin_trials,rewardTone,costTone);
        rewardTone_trialsIDX = bin_trials.StimulusID == rewardTone;
        rewardTone_licks = bin_trials.ResponseLickFrequency(rewardTone_trialsIDX);
        costTone_trialsIDX = bin_trials.StimulusID == costTone;
        costTone_licks = bin_trials.ResponseLickFrequency(costTone_trialsIDX);
        mean_rewardTone_licks_bin(n) = mean(rewardTone_licks);
        mean_costTone_licks_bin(n) = mean(costTone_licks);
         if learning_bins == 0 && learning_trials < binEnd
            learning_bins = n + 0.5;
        end
    end

    figure
    subplot(2,1,1)
    hold on
    plot([learning_bins learning_bins],[0 max([mean_costTone_licks_bin mean_rewardTone_licks_bin])],'k','LineWidth',3)
    bar([mean_rewardTone_licks_bin',mean_costTone_licks_bin'])
    xlabel(['Bins of ' num2str(bin_size) ' trials over Time'])
    ylabel(['Mean Response Lick Frequency'])
    xlim([0 numBins+1])
    ylim([0 max([mean_costTone_licks_bin mean_rewardTone_licks_bin])])
    legend('learning','Reward Tone','Cost Tone')
    
    subplot(2,1,2)
    hold on
    plot([learning_bins learning_bins],[min([dp_bin,0, c_bin]),max([dp_bin, c_bin])],'k','LineWidth',3)
    bar([dp_bin', c_bin'])
    xlabel(['Bins of ' num2str(bin_size) ' trials over Time'])
    ylabel(['D-prime and C'])
    xlim([0 numBins+1])
    ylim([min([dp_bin,0, c_bin]),max([dp_bin, c_bin])])
    legend('learning','d prime','c')

    if ~isempty(pdf_bins)
        
        tone1_pdf = tonePDF(pdf_bins_trials.ResponseLickFrequency(pdf_bins_trials.StimulusID==1),0,7);
        tone1_cdf = cumsum(tone1_pdf);

        tone2_pdf = tonePDF(pdf_bins_trials.ResponseLickFrequency(pdf_bins_trials.StimulusID==2),0,7);
        tone2_cdf = cumsum(tone2_pdf);

        subplot(2,2,3)
        hold on
        plot(0:7,tone1_pdf)
        plot(0:7,tone2_pdf)
        title(['PDF of bins ',num2str(mouse_pdf_bins(1)),' to ',num2str(mouse_pdf_bins(end))])
        xlabel('Licks')
        legend('Tone 1','Tone 2')

        subplot(2,2,4)
        hold on
        plot(0:7,tone1_cdf)
        plot(0:7,tone2_cdf)
        title(['CDF of bins ',num2str(mouse_pdf_bins(1)),' to ',num2str(mouse_pdf_bins(end))])
        xlabel('Licks')
        legend('Tone 1','Tone 2')
    end
    
    intended_strio_str = twdb(sessions_idx(1)).intendedStriosomality;
    histology_strio_str = num2str(twdb(sessions_idx(1)).histologyStriosomality);
    health_str = twdb(sessions_idx(1)).Health;
    firstSessionAge = twdb(sessions_idx(1)).firstSessionAge;
    if firstSessionAge <= 12
        age_str = 'Young';
    else
        age_str = 'Old';
    end
    supertitle({[health_str ':' mouseID ' / Age: ' age_str], ['Intended Striosomality: ',intended_strio_str,' / Histology: ',histology_strio_str]})
    if save
        figDir = ['/Users/seba/Dropbox (MIT)/UROP/HD_exp/Analysis/Lick Rates/d-prime and c figures/Bin Size ' num2str(bin_size)];
        if sum(~cellfun(@isempty,{twdb(sessions_idx).raw470Session}))
            figDir = [figDir '/Photometry ' intended_strio_str];
        end
        if ~exist(figDir)
                mkdir(figDir)
        end
        savefig([figDir '/' learning_str mouseID '_' age_str '_' health_str])
        close
    end
end
