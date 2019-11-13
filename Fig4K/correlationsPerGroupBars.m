function correlationsPerGroupBars(twdb,striosomality,engagement,normalized,xType)

miceIDs = get_mouse_ids(twdb,0,'WT','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WT_reward,WT_cost,WT_area_p] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'p-value',normalized,xType);
WT_sig = sum([WT_reward,WT_cost,WT_area_p] < 0.2,2) > 0;

[~,~,WT_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'R',normalized,xType);

WT_neg = sum(WT_area(WT_sig)<0);
WT_pos = sum(WT_area(WT_sig)>0);

miceIDs = get_mouse_ids(twdb,0,'HD','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[HD_reward,HD_cost,HD_area_p] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'p-value',normalized,xType);
HD_sig = sum([HD_reward,HD_cost,HD_area_p] < 0.2,2) > 0;

[~,~,HD_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'R',normalized,xType);

HD_neg = sum(HD_area(HD_sig)<0);
HD_pos = sum(HD_area(HD_sig)>0);

figure
bar([WT_pos,WT_neg;HD_pos,HD_neg])
legend('Positive','Negative')
ylabel('# of d-prime striosomal area correlations')
set(gca, 'xtick', 1:2, 'xticklabel', {'WT','HD'});

end