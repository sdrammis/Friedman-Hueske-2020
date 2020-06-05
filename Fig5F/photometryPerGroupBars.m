function photometryPerGroupBars(twdb,striosomality,engagement)

if isequal(engagement,'all')
    eng_str = ' All Trials';
elseif engagement
    eng_str = ' Engaged Trials';
elseif ~engagement
    eng_str = ' Not-Engaged Trials';
end

miceIDs = get_mouse_ids(twdb,0,'WT','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WT_reward,WT_cost,WT_area,WT_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'',engagement);

miceIDs = get_mouse_ids(twdb,0,'HD','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[HD_reward,HD_cost,HD_area,HD_ages] = photometryPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'',engagement);


WT = [WT_ages,WT_reward,WT_cost,WT_area];
HD = [HD_ages,HD_reward,HD_cost,HD_area];

figure('units','normalized','outerposition',[0 0 1 1])
hold on
bar([nanmean(WT_area) nanmean(HD_area)],'g')
errorbar([nanmean(WT_area) nanmean(HD_area)],...
    [std_error(WT_area) std_error(HD_area)],'.k')
plot(ones(length(WT_area)),WT_area,'ks','MarkerFaceColor','k')
plot(2*ones(length(HD_area)),HD_area,'ks','MarkerFaceColor','k')
set(gca,'XTickLabel',{'WT','HD'},'XTick',1:2)
ylabel('Response Period Photometry Area')
title('Area')

supertitle({[striosomality eng_str],''})