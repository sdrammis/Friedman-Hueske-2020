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

[~,WTresponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'WT',{},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse);

[~,HDresponse] = responseToTrial_perHealth(...
    twdb,taskReversal,'HD',{},trialNTone,trialNplusTone,Nplus,...
    responseField,wantedSessions,reverse);

meanWTresponse = nanmean(WTresponse,1);
meanHDresponse = nanmean(HDresponse,1);
serr_wt = std_error(WTresponse);
serr_hd = std_error(HDresponse);

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
plot(meanWTresponse)
plot(meanHDresponse)
errorbar(meanWTresponse,serr_wt,'.b')
errorbar(meanHDresponse,serr_hd,'.r')
xlim([0.5 3.5])
ylabel(responseField)
set(gca,'XTickLabel',x_string,'XTick',1:3)
legend('WT','HD')
if Nplus
    title({['Response to (Tone ',num2str(trialNplusTone),' | Tone  ',num2str(trialNTone),') ',num2str(Nplus),' trial before'],['Sessions: ',session_str]})
else
    title({['Response to Tone ',num2str(trialNTone),' in Same Trial'],['WT (n = ',num2str(size(WTresponse,1)),')/HD (n = ',num2str(size(HDresponse,1)),') Sessions: ',session_str]})
end

