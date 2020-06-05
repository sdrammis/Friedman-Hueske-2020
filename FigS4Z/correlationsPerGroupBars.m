function sm_ratio = correlationsPerGroupBars(twdb,health,engagement,normalized,xType)

strio_miceIDs = get_mouse_ids(twdb,0,health,'all','Strio','all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,strio_miceIDs,0,0);
[Strio_reward,Strio_cost,Strio_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,strio_miceIDs,'','',engagement,'R',normalized,xType);
Strio_sig = sum(abs([Strio_reward,Strio_cost,Strio_area]) > 0.7,2) > 0;

Strio_strong_reward = sum(abs(Strio_reward(Strio_sig))>0.7);
Strio_not_strong_reward = sum(abs(Strio_reward(Strio_sig))<=0.7);

matrix_miceIDs = get_mouse_ids(twdb,0,health,'all','Matrix','all','all',1,{});
[miceTrials,miceFluorTrials,rewardTones,costTones] = get_all_trials(twdb,matrix_miceIDs,0,0);
[Matrix_reward,Matrix_cost,Matrix_area] = correlationsPerGroup(twdb,miceTrials,miceFluorTrials,rewardTones,costTones,matrix_miceIDs,'','',engagement,'R',normalized,xType);
Matrix_sig = sum(abs([Matrix_reward,Matrix_cost,Matrix_area]) > 0.7,2) > 0;


Matrix_strong_reward = sum(abs(Matrix_reward(Matrix_sig))>0.7);
Matrix_not_strong_reward = sum(abs(Matrix_reward(Matrix_sig))<=0.7);

bar([Strio_strong_reward/length(strio_miceIDs),Strio_not_strong_reward/length(strio_miceIDs);Matrix_strong_reward/length(matrix_miceIDs),Matrix_not_strong_reward/length(matrix_miceIDs)])
legend('Strong','Not Strong')
ylabel('% of d-prime striosomal reward correlations')
set(gca, 'xtick', 1:2, 'xticklabel', {'Strio','Matrix'});
ylim([0 1])
title(health)

strioStrong = Strio_strong_reward/length(strio_miceIDs);
matrixStrong = Matrix_strong_reward/length(matrix_miceIDs);
sm_ratio = (strioStrong-matrixStrong)/(strioStrong+matrixStrong);

end
