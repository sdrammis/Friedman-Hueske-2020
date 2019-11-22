function miceType = injectMiceType_learning(twdb,miceType,firstTask)

miceIDs = unique(twdb_lookup(twdb,'mouseID'));
upToLearned = 0;
[miceTrials,rewardTones,costTones] = get_mouse_trials(twdb,miceIDs,upToLearned,~firstTask);

if firstTask
    for n = 1:length(miceType)
        miceType(n).learnedFirstTask = -1;
        miceType(n).learnedFirstTaskSessions = -1;
    end
else
    for n = 1:length(miceType)
        miceType(n).learnedReversalTask = -1;
        miceType(n).learnedReversalTaskSessions = -1;
    end
end

for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
    mouseTrials = miceTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    if rewardTone ~= -1
        learned_trials = ks_thresh_trialBins(mouseTrials,5,1,1,rewardTone,costTone,200,2);
        mouse_idx = first(twdb_lookup(miceType,'index','key','ID',mouseID));
        if ~isempty(learned_trials)
            if firstTask
                miceType(mouse_idx).learnedFirstTask = learned_trials;
                miceType(mouse_idx).learnedFirstTaskSessions = mouseTrials.SessionNumber(learned_trials);
            else
                miceType(mouse_idx).learnedReversalTask = learned_trials;
                miceType(mouse_idx).learnedReversalTaskSessions = mouseTrials.SessionNumber(learned_trials);
            end
        end
    end
end