function correlationsPerGroupBars(twdb,striosomality,engagement,normalized,xType)

miceIDs = get_mouse_ids(twdb,0,'WT','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WT_reward,WT_cost] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'p-value',normalized,xType);
WT_sig_reward =sum(WT_reward < 0.2);
WT_sig_cost = sum(WT_cost < 0.2);

miceIDs = get_mouse_ids(twdb,0,'HD','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[HD_reward,HD_cost] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'p-value',normalized,xType);
HD_sig_reward = sum(HD_reward < 0.2);
HD_sig_cost = sum(HD_cost < 0.2);

figure
bar([WT_sig_reward,WT_sig_cost;HD_sig_reward,HD_sig_cost])
legend('Reward','Cost')
ylabel('# mice with sig correlations')
set(gca, 'xtick', 1:2, 'xticklabel', {'WT','HD'});

end