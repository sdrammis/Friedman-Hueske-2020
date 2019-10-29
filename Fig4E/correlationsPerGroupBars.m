function correlationsPerGroupBars(twdb,statType,engagement,normalized,xType)

miceIDs = {'64'};
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','Strio HD learned',engagement,statType,normalized,xType);
