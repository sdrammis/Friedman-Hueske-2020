function plotBars(twdb)

figure
subplot(2,1,1)
hold on
sm_ratioWT = correlationsPerGroupBars(twdb,'WT',1,0,'dPrime');
subplot(2,1,2)
hold on
sm_ratioHD = correlationsPerGroupBars(twdb,'HD',1,0,'dPrime');


figure
bar([sm_ratioWT sm_ratioHD])
set(gca, 'xtick', 1:2, 'xticklabel', {'WT','HD'});
ylabel('Ratio')
title('% of d-prime striosomal reward correlations')