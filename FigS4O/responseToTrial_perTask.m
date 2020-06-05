function responseToTrial_perTask(twdb,taskReversal,trialNTone,trialNplusTone,...
    Nplus,responseField,wantedSessions,reverse)
% Plots responseField of Trial N + Nplus in response of amount of light
% (trialNTone = 2) or milk (trialNTone = 1) given in trial N. responseField
% is averaged across wanted sessions for WT and HD mice.
%- twdb (struct): database to be used
%- taskType (string): task to be studied
%- trialNTone (int): tone of trial N 
%- trialNplusTone (int): tone of trial N + Nplus
%- Nplus (0 or 1): if 0 - plots response of same trial, if 1 - plots response
%of trial N+1
%- responseField (string): Field of trialData to be studied
%- wantedSessions (array of int): sessions to be studied
%- reverse (0 or 1): if 0 - sessions are wanted sessions, if 1 - sessions are
%N - wantedSessions

[~,youngStrioWTResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Strio',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'young', 'WT',1);

[~,mediumStrioWTResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Strio',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'medium', 'WT',1);

[~,youngStrioHDResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Strio',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'young', 'HD',1);

[~,mediumStrioHDResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Strio',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'medium', 'HD',0);

[~,youngMatrixWTResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Matrix',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'young', 'WT',1);

[~,mediumMatrixWTResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Matrix',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'medium', 'WT',1);


[~,youngMatrixHDResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Matrix',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'young', 'HD',1);


[~,mediumMatrixHDResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Matrix',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'medium', 'HD',0);

[~,oldStrioWTResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Strio',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'old', 'WT',1);

[~,oldStrioHDResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Strio',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'old', 'HD',1);

[~,oldMatrixWTResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Matrix',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'old', 'WT', 1);


[~,oldMatrixHDResponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'Matrix',{'282','2968','4199','49'},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse, 'old', 'HD',0);

    
if trialNTone == 1
    title_str = 'Milk';
    x_string = {'4 µL','12 µL','24 µL'};
elseif trialNTone == 2
    title_str = 'Light';
    x_string = {'6 lux','60 lux','600 lux'};
end

session_str = [];
if reverse
    for n = 1:length(wantedSessions)
        if wantedSessions(n) == 0
            session_str = [session_str, 'N '];
        else
            session_str = [session_str,'N-',num2str(wantedSessions(n)),' '];
        end
    end
else
    for n = 1:length(wantedSessions)
        session_str = [session_str, num2str(wantedSessions(n)),' '];
    end
end

figure
hold on
plot_bars_and_error(youngStrioWTResponse)
plot_bars_and_error(mediumStrioWTResponse)
plot_bars_and_error(oldStrioWTResponse)
plot_bars_and_error(youngMatrixWTResponse)
plot_bars_and_error(mediumMatrixWTResponse)
plot_bars_and_error(oldMatrixWTResponse)

plot_bars_and_error(youngStrioHDResponse)
plot_bars_and_error(mediumStrioHDResponse)
plot_bars_and_error(oldStrioHDResponse)
plot_bars_and_error(youngMatrixHDResponse)
plot_bars_and_error(mediumMatrixHDResponse)
plot_bars_and_error(oldMatrixHDResponse)

xlim([0.5 3.5])
ylabel(responseField)
set(gca,'XTickLabel',x_string,'XTick',1:3)
legend('Young Strio WT','Medium Strio WT', 'Old Strio WT', ...
    'Young Matrix WT','Medium Matrix WT', 'Old Matrix WT', ...
    'Young Strio HD', 'Medium Strio HD (Not Learned)','Old Strio HD', ... 
    'Young Matrix HD','Medium Matrix HD (Not Learned)', 'Old Matrix HD (Not Learned)')

end
