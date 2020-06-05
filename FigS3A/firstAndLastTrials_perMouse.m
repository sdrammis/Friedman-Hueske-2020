function [firstTrials,lastTrials] = firstAndLastTrials_perMouse(numTrials,miceTrials,miceFluorTrials,rewardTones,costTones,plotType)

firstTrials = [];
lastTrials = [];

for m = 1:length(miceTrials)
    mouseTrials = miceTrials{m};
    mouseFluorTrials = miceFluorTrials{m};
    rewardTone = rewardTones(m);
    costTone = costTones(m);
    
    first_mouseTrials = mouseTrials(1:numTrials,:);
    first_fluorTrials = mouseFluorTrials(1:numTrials,:);
    
    first_stat = getStat(plotType,first_mouseTrials,first_fluorTrials,rewardTone,costTone);
    
    last_mouseTrials = mouseTrials(end-(numTrials-1):end,:);
    last_fluorTrials = mouseFluorTrials(end-(numTrials-1):end,:);
    
    last_stat = getStat(plotType,last_mouseTrials,last_fluorTrials,rewardTone,costTone);
    
    firstTrials = [firstTrials first_stat];
    lastTrials = [lastTrials last_stat];
    
end