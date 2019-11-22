function [trialData,mean_tone_duration] = get_trialData(trials,response_time)
%Extracts data from trials
warnStruct = warning('off','MATLAB:table:RowsAddedExistingVars');
tone_duration = [];
trialData = cell2table({});
for n = 1:length(trials)
    trial_data = trials{n};

    [tone_id,tone_on,current_tone_duration,tone_off,tone_vol] = getToneInfo(trial_data);

    if ~isnan(tone_id) %If tone_id is nan then trial is bad
        if isempty(current_tone_duration)
           if isempty(tone_duration)
               current_tone_duration = 2000;
           elseif isempty(tone_off)
               current_tone_duration = tone_duration(end);
           else
               current_tone_duration = tone_off-tone_on;
           end
        end
        if isempty(tone_off)
            tone_off = tone_on + current_tone_duration;
        end
        
        tone_duration = [tone_duration current_tone_duration];
        
        %Extraction of solonoid/LED setting
        if sum(trial_data(:,2)==14)%14 is solonoid on id
            if sum(trial_data(:,2)==14) == 1
                solenoid = 1;
            elseif sum(trial_data(:,2)==14) == 3
                solenoid = 2;
            elseif sum(trial_data(:,2)==14) == 6
                solenoid = 3;
            else
                solenoid = 0;
            end
        else
            solenoid = 0;
        end


        if sum(trial_data(:,2)==17)%17 is LED on id
            if log10(trial_data(trial_data(:,2)==18,3)) < 1 
                LED = 1;
            elseif log10(trial_data(trial_data(:,2)==18,3)) < 2
                LED = 2;
            elseif log10(trial_data(trial_data(:,2)==18,3)) < 3
                LED = 3;
            else
                LED = 0;
            end
        else
            LED = 0;
        end

        %Times when the mouse licks
        lick_times = trial_data(trial_data(:,2)==13,1);

        %Response Period Data (Defined from tone off)
        response_licks = lick_times(lick_times((tone_off+response_time)>lick_times)>tone_off);%time of licks in respose period
        response_frequency = length(response_licks)/(response_time/1000);%lick frequency in respose period in Hz
        responseILI = mean(diff(response_licks)/1000);%Inter-lick Interval in respose period in sec

        if ~isempty(lick_times)
            %Reaction Time = Time from tone off to first lick in sec
            reaction_time = (lick_times(1)-tone_off)/1000;
        else
            reaction_time = NaN;
        end

        %Length of Inter-Trial Interval period
        ITI_start = trial_data(trial_data(:,2)==9,1);
        ITI_end = trial_data(trial_data(:,2)==10,1);
        ITI_length = (ITI_end-ITI_start)/1000;

        %Outcome Period Data (Defined from end of Response Period to ITI start)
        outcome_licks = lick_times(lick_times(ITI_start>lick_times)>(tone_off+response_time));%time of licks in outcome period
        outcome_time = (ITI_start - (tone_off+response_time))/1000;
        outcome_frequency = length(outcome_licks)/outcome_time;%lick frequency in outcome period in Hz
        outcomeILI = mean(diff(outcome_licks)/1000);%Inter-lick Interval in outcome period in sec

        %Placing trial data in table
        trialData.StimulusID(n) = tone_id;
        if ~isnan(tone_vol)
            trialData.Volume(n) = tone_vol;
        end
        trialData.Solenoid(n) = solenoid;
        trialData.LED(n) = LED;
        trialData.ReactionTime(n) = reaction_time;
        trialData.LicksInResponse(n) = length(response_licks);
        trialData.LicksInOutcome(n) = length(outcome_licks);
        trialData.LengthOfITI(n) = ITI_length;
        trialData.ResponseLickFrequency(n) = response_frequency;
        trialData.ResponseILI(n) = responseILI;
        trialData.OutcomeLickFrequency(n) = outcome_frequency;
        trialData.OutcomeILI(n) = outcomeILI;
        trialData.TrialStartTime(n) = trials{n}(1,1); %start of trial
        trialData.ToneStartTime(n) = tone_on; %Time of tone start
        trialData.ResponseStartTime(n) = tone_off; %reaction time start
        trialData.OutcomeStartTime(n) = tone_off+response_time; %outcome time start
        trialData.OutcomeEndTime(n) = ITI_start; %Outcome time end
        trialData.ITIEndTime(n) = ITI_end; 
    end
    clear tone_id;
end
mean_tone_duration = nanmean(tone_duration);
warning(warnStruct);