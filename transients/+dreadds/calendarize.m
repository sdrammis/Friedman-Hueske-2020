function cal = calendarize(nSpikes, sessionTime, sessions)
varNames = {'Weekday', 'Injection', 'Concentration', 'Deval', 'SpikesHZ', 'didRun', 'TaskType', 'SessionNumber'};
cal = table(0, {[]}, {[]}, {[]}, nan, false, 0, {[]}, 'VariableNames', varNames);

prevday = nan;
for jj=1:length(sessions)
    session = sessions(jj);
    day = session.sessionDate;
    if isnan(prevday)
        dayNum = weekday(day);
        inj = session.injection;
        conctr = session.concentration;
        deval = session.devaluation;
        spikesHZ = nSpikes(jj) / sessionTime(jj);
        taskType = session.taskType;
        sessionNum = session.sessionNumber;
        cal = [cal; {dayNum inj conctr deval spikesHZ true taskType sessionNum}];

        prevday = day;
        continue;
    end
    
    diff = daysact(prevday, day);
    if diff > 1
        cal = [cal; {0 [] [] [] 0 false [] 0}];
    end
    dayNum = weekday(day);
    inj = session.injection;
    conctr = session.concentration;
    deval = session.devaluation;
    spikesHZ = nSpikes(jj) / sessionTime(jj);
    taskType = session.taskType;
    sessionNum = session.sessionNumber;
    cal = [cal; {dayNum inj conctr deval spikesHZ true taskType sessionNum}];
    
    prevday = day;
end
cal = [cal; {0 [] [] [] 0 false [] 0}];
end
