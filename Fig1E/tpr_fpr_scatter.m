% Author: QZ
% 06/13/2019
function tpr_fpr_scatter(x,y,size,clrMp,titleStr,dp,c)
% x  x data (array of nums) (FPR)
% y  y data (same length as x) (TPR)
% size  size of markers
% clrMp  matrix of RGB triples of same height as x and y
% xLab,yLab,titleStr  strings for x label, y label, and title
% dp  array of dp
% c  array of c
hold on;
xlim([0,1]);
ylim([0,1]);
plot([0 1],[0 1],'k--');
hold on;
plot([0 1],[1 0],'k--');
dCurve = plot_isosensitivity(mean(dp),'BLACK');
cCurve = plot_isobias(mean(c),'LIGHTCORAL');
% can modify for 'filled',mkr etc.
scatter(x,y,size,clrMp,'filled');
hold off;
xlabel('FPR');
ylabel('TPR');
title(titleStr);
sem_dp = calcSE(dp);
sem_c = calcSE(c);
legend([dCurve, cCurve], ...
    {['d'': ' num2str(round(mean(dp),2)) ', SEM: ' num2str(round(sem_dp,2))], ...
    ['c: ' num2str(round(mean(c),2)) ', SEM: ' num2str(round(sem_c,2))]}, ...
    'Location', 'best');
hold off;
end