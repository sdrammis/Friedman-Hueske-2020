function mouseDistributions = mouseDistributions_DREADD(twdb,period,mouse_sessions,normalizationType,bin_size)

mouseDistributions = table;
mouseID = twdb(mouse_sessions(1)).mouseID;
if ~isequal(normalizationType,'no')
    for s = 1:length(mouse_sessions)
        sessionIdx = mouse_sessions(s);
        if isnan(sessionIdx)
            continue
        end
        taskType = twdb(sessionIdx).taskType;
        sessionNum = twdb(sessionIdx).sessionNumber;
        beforeSessionNum = sessionNum-1;

        if beforeSessionNum <= 0
            continue
        end

        beforeSessionIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','taskType',taskType,...
            'key','sessionNumber',beforeSessionNum));
        sessionBeforeDistributions = sessionDistributions_DREADD(twdb,beforeSessionIdx,period,bin_size);
        
        if isempty(sessionBeforeDistributions)
            continue
        end

        sessionDistributions = sessionDistributions_DREADD(twdb,sessionIdx,period,bin_size);

        normalizedDistributions = normalizeDistributions_DREADD(sessionBeforeDistributions,sessionDistributions,normalizationType);
        
        mouseDistributions = [mouseDistributions; normalizedDistributions];
    end
else
    for s = 1:length(mouse_sessions)
        sessionIdx = mouse_sessions(s);
        sessionDistributions = sessionDistributions_DREADD(twdb,sessionIdx,period,bin_size);
        mouseDistributions = [mouseDistributions; sessionDistributions];
    end
end