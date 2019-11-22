function twdb = injectSpecialSessions(twdb,fileToInject)

load(fileToInject)
if contains(fileToInject,'Devaluation')
    if contains(fileToInject,'water')
        devaluationFile = waterDevaluation;
        devaluationType = 'Water';
    elseif contains(fileToInject,'sucrose')
        devaluationFile = sucroseDevaluation;
        devaluationType = 'Sucrose';
    end
    for m = 1:length(devaluationFile)
        mouseID = num2str(devaluationFile(m).mouseID);
        dates = devaluationFile(m).devaluationDate;
        if isempty(twdb_lookup(twdb,'index','key','mouseID',mouseID))
            continue
        end
        for d = 1:length(dates)
            devaluationIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','sessionDate',dates{d}));
            twdb(devaluationIdx).devaluation = devaluationType;
        end
    end
elseif contains(fileToInject,'Injections')
    if contains(fileToInject,'cnoApomorphine')
        injectionFile = cnoApomorphineInjections;
        injectionType = 'CNO + Apomorphine';
        for m = 1:length(injectionFile)
            mouseID = num2str(injectionFile(m).mouseID);
            dates = injectionFile(m).injectionDate;
            concentrations = injectionFile(m).concentration;
            if isempty(twdb_lookup(twdb,'index','key','mouseID',mouseID))
                continue
            end
            for d = 1:length(dates)
                injectionIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','sessionDate',dates{d}));
                twdb(injectionIdx).injection = injectionType;
                twdb(injectionIdx).concentration = concentrations{d};
            end
        end
    else
        if contains(fileToInject,'saline')
            injectionFile = salineInjections;
            injectionType = 'Saline';
        elseif contains(fileToInject,'cno')
            injectionFile = cnoInjections;
            injectionType = 'CNO';
        elseif contains(fileToInject,'diazepam')
            injectionFile = diazepamInjections;
            injectionType = 'Diazepam';
        elseif contains(fileToInject,'apomorphine')
            injectionFile = apomorphineInjections;
            injectionType = 'Apomorphine';
        end
        for m = 1:length(injectionFile)
            mouseID = num2str(injectionFile(m).mouseID);
            dates = injectionFile(m).injectionDate;
            concentrations = injectionFile(m).concentration;
            if isempty(twdb_lookup(twdb,'index','key','mouseID',mouseID))
                continue
            end
            for d = 1:length(dates)
                injectionIdx = first(twdb_lookup(twdb,'index','key','mouseID',mouseID,'key','sessionDate',dates{d}));
                twdb(injectionIdx).injection = injectionType;
                twdb(injectionIdx).concentration = concentrations(d);
            end
        end
    end
end