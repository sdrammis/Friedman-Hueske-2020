function photometryPerGroupBars(twdb,striosomality,engagement)

if isequal(engagement,'all')
    eng_str = ' All Trials';
elseif engagement
    eng_str = ' Engaged Trials';
elseif ~engagement
    eng_str = ' Not-Engaged Trials';
end

miceIDs = get_mouse_ids(twdb,0,'WT',1,striosomality,'all','young',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[youngWTlearned_reward,youngWTlearned_cost,youngWTlearned_area,youngWTlearned_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'young',engagement);

miceIDs = get_mouse_ids(twdb,0,'HD',1,striosomality,'all','young',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[youngHDlearned_reward,youngHDlearned_cost,youngHDlearned_area,youngHDlearned_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'young',engagement);


youngWTlearned = [youngWTlearned_ages,youngWTlearned_reward,youngWTlearned_cost,youngWTlearned_area];
youngHDlearned = [youngHDlearned_ages,youngHDlearned_reward,youngHDlearned_cost,youngHDlearned_area];

figure('units','normalized','outerposition',[0 0 1 1])

subplot(3,1,1)
hold on
bar([nanmean(youngWTlearned_reward) nanmean(youngHDlearned_reward)],'b')
errorbar([nanmean(youngWTlearned_reward) nanmean(youngHDlearned_reward)],...
    [std_error(youngWTlearned_reward) std_error(youngHDlearned_reward)],'.k')
plot(ones(length(youngWTlearned_reward)),youngWTlearned_reward,'ks','MarkerFaceColor','k')
plot(2*ones(length(youngHDlearned_reward)),youngHDlearned_reward,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned','HD learned'},'XTick',1:2)
ylabel('Response Period Photometry Sum')
title('Reward')

subplot(3,1,2)
hold on
bar([nanmean(youngWTlearned_cost) nanmean(youngHDlearned_cost)],'r')
errorbar([nanmean(youngWTlearned_cost) nanmean(youngHDlearned_cost)],...
    [std_error(youngWTlearned_cost) std_error(youngHDlearned_cost)],'.k')
plot(ones(length(youngWTlearned_cost)),youngWTlearned_cost,'ks','MarkerFaceColor','k')
plot(2*ones(length(youngHDlearned_cost)),youngHDlearned_cost,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned','HD learned'},'XTick',1:2)
ylabel('Response Period Photometry Sum')
title('Cost')

subplot(3,1,3)
hold on
bar([nanmean(youngWTlearned_area) nanmean(youngHDlearned_area)],'g')
errorbar([nanmean(youngWTlearned_area) nanmean(youngHDlearned_area)],...
    [std_error(youngWTlearned_area) std_error(youngHDlearned_area)],'.k')
plot(ones(length(youngWTlearned_area)),youngWTlearned_area,'ks','MarkerFaceColor','k')
plot(2*ones(length(youngHDlearned_area)),youngHDlearned_area,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned','HD learned'},'XTick',1:2)
ylabel('Response Period Photometry Area')
title('Area')

supertitle({[striosomality eng_str],''})