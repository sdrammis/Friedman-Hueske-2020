function twdb = makeLightDB(twdb)

twdb = rmfield(twdb, 'sessionYear');
twdb = rmfield(twdb, 'sessionMonth');
twdb = rmfield(twdb, 'sessionDay');
twdb = rmfield(twdb, 'sessionHour');
twdb = rmfield(twdb, 'sessionMinute');
twdb = rmfield(twdb, 'boxN');
twdb = rmfield(twdb, 'eventData');
twdb = rmfield(twdb, 'birthDate');
twdb = rmfield(twdb, 'filename');
twdb = rmfield(twdb, 'trials');
twdb = rmfield(twdb, 'sessionData');
twdb = rmfield(twdb, 'trialLickTimes');
twdb = rmfield(twdb, 'raw470Trials');
twdb = rmfield(twdb, 'raw405Trials');
twdb = rmfield(twdb, 'perfusionDate');

for idx = 1:length(twdb)
    trialData = twdb(idx).trialData;
    if ~isempty(trialData)
        trialData.ReactionTime = [];
        trialData.LicksInResponse = [];
        trialData.LengthOfITI = [];
        trialData.ResponseILI = [];
        trialData.OutcomeILI = [];
        trialData.SessionFilename = [];
        trialData.IDXofTrial = [];
        twdb(idx).trialData = trialData;
    end
    
end
