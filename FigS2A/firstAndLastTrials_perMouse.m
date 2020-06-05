function [firstTrials,lastTrials] = firstAndLastTrials_perMouse(ageRanges,miceTrials,miceFluorTrials,rewardTones,costTones,ages,plotType)

numTrials = 200;
firstTrials = {[],[],[]};
lastTrials = {[],[],[]};

[~,~,ageIdx] = histcounts(ages, ageRanges);

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
    
    firstTrials{ageIdx(m)} = [firstTrials{ageIdx(m)} first_stat];
    lastTrials{ageIdx(m)} = [lastTrials{ageIdx(m)} last_stat];
    
end