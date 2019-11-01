function tone_data = data_per_tone(trialData,tone,engaged,fieldname)
%Data is name of table field for data

if engaged 
    engaged_idx = table2array(trialData(:,'Engagement'))==1;
    trialData = trialData(engaged_idx,:);
end
if tone
    tone_idx = table2array(trialData(:,'StimulusID'))==tone; %Index of trials with tone
    data = table2array(trialData(:,fieldname));
    tone_data = data(tone_idx);
else
    tone_data = table2array(trialData(:,fieldname));
end