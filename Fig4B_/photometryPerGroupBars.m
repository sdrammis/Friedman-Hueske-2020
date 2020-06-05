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
[youngWTlearned_reward,youngWTlearned_cost,youngWTlearned_area,youngWTlearned_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'young',engagement);
[oldWTlearned_reward,oldWTlearned_cost,oldWTlearned_area,oldWTlearned_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'old',engagement);


youngWTlearned = [youngWTlearned_ages,youngWTlearned_reward,youngWTlearned_cost,youngWTlearned_area];
oldWTlearned = [oldWTlearned_ages,oldWTlearned_reward,oldWTlearned_cost,oldWTlearned_area];

figure('units','normalized','outerposition',[0 0 1 1])

subplot(3,1,1)
hold on
bar([nanmean(youngWTlearned_reward) nanmean(oldWTlearned_reward)],'b')
errorbar([nanmean(youngWTlearned_reward) nanmean(oldWTlearned_reward)],...
    [std_error(youngWTlearned_reward) std_error(oldWTlearned_reward)],'.k')
plot(ones(length(youngWTlearned_reward)),youngWTlearned_reward,'ks','MarkerFaceColor','k')
plot(2*ones(length(oldWTlearned_reward)),oldWTlearned_reward,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned young','WT learned old'},'XTick',1:2)
ylabel('Response Period Photometry Sum')
title('Reward')

subplot(3,1,2)
hold on
bar([nanmean(youngWTlearned_cost) nanmean(oldWTlearned_cost)],'r')
errorbar([nanmean(youngWTlearned_cost) nanmean(oldWTlearned_cost)],...
    [std_error(youngWTlearned_cost) std_error(oldWTlearned_cost)],'.k')
plot(ones(length(youngWTlearned_cost)),youngWTlearned_cost,'ks','MarkerFaceColor','k')
plot(2*ones(length(oldWTlearned_cost)),oldWTlearned_cost,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned young','WT learned old'},'XTick',1:2)
ylabel('Response Period Photometry Sum')
title('Cost')

subplot(3,1,3)
hold on
bar([nanmean(youngWTlearned_area) nanmean(oldWTlearned_area)],'g')
errorbar([nanmean(youngWTlearned_area) nanmean(oldWTlearned_area)],...
    [std_error(youngWTlearned_area) std_error(oldWTlearned_area)],'.k')
plot(ones(length(youngWTlearned_area)),youngWTlearned_area,'ks','MarkerFaceColor','k')
plot(2*ones(length(oldWTlearned_area)),oldWTlearned_area,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT learned young','WT learned old'},'XTick',1:2)
ylabel('Response Period Photometry Area')
title('Area')

supertitle({[striosomality eng_str],''})