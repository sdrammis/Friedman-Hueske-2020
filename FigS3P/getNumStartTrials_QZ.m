function numStart = getNumStartTrials_QZ(twdb,msID)
% msID should be a cell containing a single mouse ID
learnTrial = first(twdb_lookup(twdb,'learnedFirstTask','key','mouseID',msID));
if learnTrial >= 400
    numStart = 200;
elseif learnTrial >= 300 % [300,399] - 150 trials per
    numStart = 150;
elseif learnTrial >= 200 % [200,299] - 100 trials per
    numStart = 100;
elseif learnTrial >= 1 % [1,199] - shouldn't be applicable, but here anyway
    numStart = ceil(learnTrial/2);
else % -1, doesn't learn
    if numTrials >= 200
        numStart = 200;
    elseif numTrials >= 150
        numStart = 150;
    elseif numTrials >= 100
        numStart = 100;
    else
        numStart = numTrials;
    end
end
end