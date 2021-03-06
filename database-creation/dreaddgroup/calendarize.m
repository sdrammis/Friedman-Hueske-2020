function cal = calendarize(nSpikes, sessionTime, sessions, spikesGrades)
varNames = {'Weekday', 'Injection', 'Concentration', 'Deval', 'SpikesHZ', 'didRun', 'TaskType', 'SessionNumber', 'SpikesGrades', 'SessionTime'};
cal = table(0, {[]}, {[]}, {[]}, nan, false, 0, {[]}, {[]}, 0, 'VariableNames', varNames);

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
        grades = spikesGrades{jj};
        cal = [cal; {dayNum inj conctr deval spikesHZ true taskType sessionNum grades sessionTime(jj)}];

        prevday = day;
        continue;
    end
    
    diff = daysact(prevday, day);
    if diff > 1
        cal = [cal; {0 [] [] [] 0 false [] 0 [] 0}];
    end
    dayNum = weekday(day);
    inj = session.injection;
    conctr = session.concentration;
    deval = session.devaluation;
    spikesHZ = nSpikes(jj) / sessionTime(jj);
    taskType = session.taskType;
    sessionNum = session.sessionNumber;
    grades = spikesGrades{jj};
    cal = [cal; {dayNum inj conctr deval spikesHZ true taskType sessionNum grades sessionTime(jj)}];
    
    prevday = day;
end
cal = [cal; {0 [] [] [] 0 false [] 0 [] 0}];
end
