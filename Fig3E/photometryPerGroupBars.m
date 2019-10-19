function photometryPerGroupBars(twdb,striosomality,engagement)

if isequal(engagement,'all')
    eng_str = ' All Trials';
elseif engagement
    eng_str = ' Engaged Trials';
elseif ~engagement
    eng_str = ' Not-Engaged Trials';
end

miceIDs = get_mouse_ids(twdb,0,'WT',1,striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WTlearned_reward,WTlearned_cost,WTlearned_area,WTlearned_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'',engagement);

miceIDs = get_mouse_ids(twdb,0,'WT',0,striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WTnotLearned_reward,WTnotLearned_cost,WTnotLearned_area,WTnotLearned_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'',engagement);


WTlearned = [WTlearned_ages,WTlearned_reward,WTlearned_cost,WTlearned_area];
WTnotLearned = [WTnotLearned_ages,WTnotLearned_reward,WTnotLearned_cost,WTnotLearned_area];

figure('units','normalized','outerposition',[0 0 1 1])
hold on
bar([nanmean(WTlearned_area) nanmean(WTnotLearned_area)],'g')
errorbar([nanmean(WTlearned_area) nanmean(WTnotLearned_area)],...
    [std_error(WTlearned_area) std_error(WTnotLearned_area)],'.k')
plot(ones(length(WTlearned_area)),WTlearned_area,'ks','MarkerFaceColor','k')
plot(2*ones(length(WTnotLearned_area)),WTnotLearned_area,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned','WT not learned'},'XTick',1:2)
ylabel('Response Period Photometry Area')
title('Area')

supertitle({[striosomality eng_str],''})