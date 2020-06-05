function correlationsPerGroupBars(twdb,striosomality,engagement,normalized,xType)

miceIDs = get_mouse_ids(twdb,0,'WT','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WT_reward,WT_cost,WT_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'R',normalized,xType);
WT_sig = sum(abs([WT_reward,WT_cost,WT_area]) > 0.7,2) > 0;

WT_strong_reward = sum(abs(WT_reward(WT_sig))>0.7);
WT_not_strong_reward = sum(abs(WT_reward(WT_sig))<=0.7);

miceIDs = get_mouse_ids(twdb,0,'HD','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[HD_reward,HD_cost,HD_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'R',normalized,xType);
HD_sig = sum(abs([HD_reward,HD_cost,HD_area]) > 0.7,2) > 0;


HD_strong_reward = sum(abs(HD_reward(HD_sig))>0.7);
HD_not_strong_reward = sum(abs(HD_reward(HD_sig))<=0.7);

figure
bar([WT_strong_reward,WT_not_strong_reward;HD_strong_reward,HD_not_strong_reward])
legend('Strong','Not Strong')
ylabel('# of d-prime striosomal reward correlations')
set(gca, 'xtick', 1:2, 'xticklabel', {'WT','HD'});

end
