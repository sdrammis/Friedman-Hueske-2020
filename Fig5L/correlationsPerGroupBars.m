function correlationsPerGroupBars(twdb,striosomality,engagement,normalized,xType)

miceIDs = get_mouse_ids(twdb,0,'WT','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[WT_reward,WT_cost,WT_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'R',normalized,xType);
WT_sig = sum(abs([WT_reward,WT_cost,WT_area]) > 0.7,2) > 0;

miceIDs = get_mouse_ids(twdb,0,'HD','all',striosomality,'all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,miceIDs,0,0);
[HD_reward,HD_cost,HD_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,miceIDs,'','',engagement,'R',normalized,xType);
HD_sig = sum(abs([HD_reward,HD_cost,HD_area]) > 0.7,2) > 0;


WT_strong_cost = sum(abs(WT_cost(WT_sig))>0.7);
WT_not_strong_cost = sum(abs(WT_cost(WT_sig))<=0.7);

HD_strong_cost = sum(abs(HD_cost(HD_sig))>0.7);
HD_not_strong_cost = sum(abs(HD_cost(HD_sig))<=0.7);

figure
bar([WT_strong_cost,WT_not_strong_cost;HD_strong_cost,HD_not_strong_cost])
legend('Strong','Not Strong')
ylabel('# of d-prime striosomal cost correlations')
set(gca, 'xtick', 1:2, 'xticklabel', {'WT','HD'});

end
