function [responsePerHealth,meanResponsePerHealth] = responseToTrial_perHealth(...
    twdb,taskReversal,health,exceptions,trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse)

mice_ids = get_mouse_ids(twdb,taskReversal,health,'all','all','all','all',0,exceptions);

for mouse = 1:length(mice_ids)
    
    [~,responsePerMouse] = responseToTrial_perMouse(twdb,...
        taskReversal,mice_ids{mouse},trialNTone,trialNplusTone,Nplus,...
        responseField,wantedSessions,reverse);
    
    meanResponsePerHealth(mouse,1:size(responsePerMouse,2)) = nanmean(responsePerMouse,1);
    responsePerHealth{mouse} = responsePerMouse;
end