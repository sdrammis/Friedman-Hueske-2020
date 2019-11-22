function twdb = injectData_HD_DB(base_twdb,new_twdb,miceType)
%Injects data into twdb and saves it in new_twdb
%Mice Type input is miceType.mat and corresponds to mice data such as
%Date of Birth, Health, etc.

trialsRemoved = 0;

twdb = load(base_twdb); %load base twdb file
twdb = twdb.twdb;

%Takes data from miceType and injects it to TWDB
twdb = injectMiceType(twdb,miceType);

for idx=1:length(twdb)
    %Adds index field
    twdb(idx).index = idx;
    
    %Injects Day of the Week when session happened
    [~,WeekDay] = weekday(datenum(twdb(idx).sessionDate,'yyyy-mm-dd'),'long','en_US');
    twdb(idx).WeekDay = WeekDay;
    
    %Injects event data split into trials 
    eventData = twdb(idx).eventData;
    trials = get_trials(eventData,trialsRemoved);
    twdb(idx).trials = trials';
    
    %Session Data gets injected as a table
    time_column = 1;
    event_column = 2;
    value_column = 3;
    response_duration = eventData((eventData(:,2)==60),value_column);
    
    
    %Trial Data gets injected as a table where each row is a trial
    if ~isempty(trials)
        [trialData,tone_duration] = get_trialData(trials,response_duration);
        %Trials mapped to original session filename
        filename = cell(height(trialData),1);
        filename(:) = {twdb(idx).filename};
        trialData.SessionFilename = filename;
        %Trials indexed
        trialData.IDXofTrial = [1:height(trialData)]';

        %Data to DB
        twdb(idx).trialData = trialData;
        
        twdb(idx).sessionData = ...
        table([tone_duration/1000],[response_duration/1000],[length(trials)],...
        'VariableNames',{'ToneDuration','ResponseDuration','NumberOfTrials'});
    end
    
    %Add Trial Lick Times
    lick_id = 13;
    trialLickTimes = cell(length(trials),1);
    for t = 1:length(trials)
        trial = trials{t};
        lick_idx = trial(:,event_column)==lick_id;
        trialLickTimes{t} = trial(lick_idx,time_column);
    end
    twdb(idx).trialLickTimes = trialLickTimes;
    
    twdb(idx).concentration = -1;
    twdb(idx).devaluation = '';
    twdb(idx).injection = '';
    
end

%Fix session numbers
twdb = correctSessionNumbers(twdb);

%Extract raw photometry data
twdb = extractRawPhotometry(twdb);

save(new_twdb,'twdb','-v7.3')