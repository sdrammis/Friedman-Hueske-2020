function learningTrials = getLearningTrials(twdb,miceIDs)

learningTrials = [];
for m = 1:length(miceIDs)
    learningTrials(m) = first(twdb_lookup(twdb,'learnedFirstTask','key','mouseID',miceIDs{m}));
end