function [mouseTrials,fluorTrials,rewardTone,costTone,sessFluorAll] = behaviorAndFluorescenceData(twdb, mouseID,sessionIdx)
    
    mouseTrials = table;
    fluorTrials = [];
    rewardTone = NaN;
    costTone = NaN;
    for idx = sessionIdx
        if isnan(idx)
            continue
        end
        trialData = twdb(idx).trialData;
        rewardTone = twdb(idx).rewardTone;
        costTone = twdb(idx).costTone;
        if isempty(trialData)
            continue
        end
        mouseTrials = [mouseTrials; trialData];
        [sessFluorTrials] = get_session_fluorescence_sta(twdb, mouseID, idx, 'all', false);
        if isempty(sessFluorTrials)
            fluorTrials = [fluorTrials; nan(height(trialData),98)];
            continue;
        end

        sessFluorAll = get_session_fluorescence_sta(twdb, mouseID, idx, 'all', true);
        numSessionTrials = size(sessFluorTrials, 1);
        for i=1:numSessionTrials
            zSessFluor = zscore_baseline(sessFluorTrials(i, :), sessFluorAll);
            fluorTrials = [fluorTrials; zSessFluor];
        end
    end
    
    
    
end
        
        
function ret = zscore_baseline(data, base)
    m = mean(base);
    s = std(base);
    ret = arrayfun(@(x) (x - m) / s, data);
end