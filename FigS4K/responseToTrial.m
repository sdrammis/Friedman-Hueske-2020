function [responseToTone,responding_idx] = responseToTrial(trialData,tralNTone_idx,trialNplusTone,Nplus,responseField)

respondingTrialData = trialData(tralNTone_idx+Nplus,:);

responding_idx = find(table2array(respondingTrialData(:,'StimulusID'))==trialNplusTone);

responseToTone = table2array(respondingTrialData(responding_idx,responseField));
