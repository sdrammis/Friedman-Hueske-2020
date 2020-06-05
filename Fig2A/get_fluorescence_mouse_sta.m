function [bin_fluorRewardTrials,bin_fluorCostTrials,bin_lickRewardTrials,bin_lickCostTrials,mean_all_licks,std_all_licks]...
    = get_fluorescence_mouse_sta(twdb, mouseID, bin_size, engagement,zscore,learningPeriod)
    fluorTrials = [];
    
    sessionIdx = get_mouse_sessions(twdb,mouseID,1,0,'all',0);
    mouseTrials = table;
    for idx = sessionIdx
        trialData = twdb(idx).trialData;
        if ~isempty(trialData)
            mouseTrials = [mouseTrials; trialData];
        end
    end
    
    if zscore
        all_licks = mouseTrials.ResponseLickFrequency;
        mean_all_licks = nanmean(all_licks);
        std_all_licks = nanstd(all_licks);
    end
    
    if ~isequal('all',engagement)
        mouseTrials = mouseTrials(mouseTrials.Engagement == engagement,:);
        
    end

    rewardTone = twdb(sessionIdx(1)).rewardTone;
    costTone = twdb(sessionIdx(1)).costTone;

    for idx = sessionIdx
        trialData = twdb(idx).trialData;
        if isempty(trialData)
            continue
        end
        [sessFluorTrials] = get_session_fluorescence_sta(twdb, mouseID, idx, engagement, false);
        
        if ~isequal('all',engagement)
            trialData = trialData(trialData.Engagement == engagement,:);
        end
        if isempty(sessFluorTrials)
            fluorTrials = [fluorTrials; nan(height(trialData),98)];
            continue;
        end

        sessFluorAll = get_session_fluorescence_sta(twdb, mouseID, idx, engagement, true);
        
        numSessionTrials = size(sessFluorTrials, 1);
        for i=1:numSessionTrials
            zSessFluor = zscore_baseline(sessFluorTrials(i, :), sessFluorAll);
            fluorTrials = [fluorTrials; zSessFluor];
        end
    end
    
    numTrials = height(mouseTrials);
    numTrials = round(numTrials*learningPeriod);
%     bin_size = round(0.05*height(mouseTrials));
    if ~isequal(bin_size,'all')
        numBins = ceil(numTrials/bin_size);

        for n = numBins:-1:1
            binEnd = numTrials-(numBins-n)*bin_size;
            if n == 1
                binStart = 1;
            else
                binStart = binEnd-bin_size+1;
            end
            bin_trialData = mouseTrials(binStart:binEnd,:);
            bin_fluorTrials = fluorTrials(binStart:binEnd,:);
            rewardToneIdx = bin_trialData.StimulusID == rewardTone;
            costToneIdx = bin_trialData.StimulusID == costTone;

            bin_fluorRewardTrials{n} = bin_fluorTrials(rewardToneIdx,:);
            bin_fluorCostTrials{n} = bin_fluorTrials(costToneIdx,:);

            lickRewardTrials = bin_trialData.ResponseLickFrequency(rewardToneIdx);
            lickCostTrials = bin_trialData.ResponseLickFrequency(costToneIdx);

            if zscore
                bin_lickRewardTrials{n} = (lickRewardTrials-mean_all_licks)/std_all_licks;
                bin_lickCostTrials{n} = (lickCostTrials-mean_all_licks)/std_all_licks;
            else
                bin_lickRewardTrials{n} = lickRewardTrials;
                bin_lickCostTrials{n} = lickCostTrials;
            end
        end
    else
        mouseTrials = mouseTrials(1:numTrials,:);
        rewardToneIdx = mouseTrials.StimulusID == rewardTone;
        bin_fluorRewardTrials = fluorTrials(rewardToneIdx,:);
        costToneIdx = mouseTrials.StimulusID == costTone;
        bin_fluorCostTrials = fluorTrials(costToneIdx,:);
        
        lickRewardTrials = mouseTrials.ResponseLickFrequency(rewardToneIdx);
        lickCostTrials = mouseTrials.ResponseLickFrequency(costToneIdx);
        
        if zscore
            bin_lickRewardTrials = (lickRewardTrials-mean_all_licks)/std_all_licks;
            bin_lickCostTrials = (lickCostTrials-mean_all_licks)/std_all_licks;
        else
            bin_lickRewardTrials = lickRewardTrials;
            bin_lickCostTrials = lickCostTrials;
        end
    end
end

