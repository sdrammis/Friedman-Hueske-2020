function [responsePerHealth,meanResponsePerHealth] = responseToTrial_perHealth(...
    twdb,taskReversal,intendedStriosomality,exceptions,trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, age, health, learned)

mice_ids = get_mouse_ids(twdb,taskReversal,health,learned, intendedStriosomality,'all',age,'all',exceptions);

for mouse = 1:length(mice_ids)
    
    [~,responsePerMouse] = responseToTrial_perMouse(twdb,...
        taskReversal,mice_ids{mouse},trialNTone,trialNplusTone,Nplus,...
        responseField,wantedSessions,reverse);
    
    meanResponsePerHealth(mouse,1:size(responsePerMouse,2)) = nanmean(responsePerMouse,1);
    responsePerHealth{mouse} = responsePerMouse;
end