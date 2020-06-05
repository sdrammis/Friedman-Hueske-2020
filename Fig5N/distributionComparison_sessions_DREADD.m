function miceDistributions = distributionComparison_sessions_DREADD(twdb,DREADDtype,striosomality,health,photometry,numSessions)

period = 'Response';
normalizationType = 'no';
miceIDs = get_DREADD_ids(twdb,0,DREADDtype,health,'all',striosomality,'all','all',photometry,{});
concentration = 'all';
miceDistributions = struct;
bin_size = 10;
cnoDistributions = [];
salineDistributions = [];
for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
        
    cno_sessions = getInjectionSessions(twdb,mouseID,'CNO',concentration,1,'all',0,0);
    if ~isequal(numSessions,'all')
        if length(cno_sessions) < numSessions
            continue
        end
        cno_sessions = cno_sessions(1:numSessions);
    end
    cnoDistributions_mouse = mouseDistributions_DREADD(twdb,period,cno_sessions,normalizationType,bin_size);
    
    cnoDistributions = [cnoDistributions; cnoDistributions_mouse];
    
    if isequal(normalizationType,'no')
        before_sessions = nan(1,length(cno_sessions));
        after_sessions = nan(1,length(cno_sessions));
        for s = 1:length(cno_sessions)
            session = cno_sessions(s);
            taskType = twdb(session).taskType;
            sessionDate = datetime(twdb(session).sessionDate,'InputFormat','yyyy-MM-dd');
            beforeDate = datestr(sessionDate + days(-1),'yyyy-mm-dd');
            afterDate = datestr(sessionDate + days(1),'yyyy-mm-dd');

            before_idx = twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','taskType',taskType,...
                'key','sessionDate',beforeDate);
            after_idx = twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','taskType',taskType,...
                'key','sessionDate',afterDate);
            if ~isempty(before_idx)
                before_sessions(s) = first(before_idx);
            end
            if ~isempty(after_idx)
                after_sessions(s) = first(after_idx);
            end
        end
        sal_sessions = [before_sessions(~isnan(before_sessions)) after_sessions(~isnan(after_sessions))];
        salineDistributions_mouse = mouseDistributions_DREADD(twdb,period,sal_sessions,normalizationType,bin_size);
        salineDistributions = [salineDistributions; salineDistributions_mouse];
    end
    
end
miceDistributions(1).mouseNum = length(miceIDs);
miceDistributions(1).cnoDistributions = cnoDistributions;
miceDistributions(1).salineDistributions = salineDistributions;