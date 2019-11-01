function [tone_idx,level] = outcome_level(trialData,tone)

tone_idx = find(table2array(trialData(:,'StimulusID'))==tone);

if tone == 1
    level_field = 'Solenoid';
elseif tone == 2
    level_field = 'LED';
end
level = table2array(trialData(tone_idx,level_field));