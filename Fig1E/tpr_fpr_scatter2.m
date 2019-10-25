% Author: QZ
% 06/13/2019
% plots scatter plot of trials over time. Same trial section is same color
% as opposed to individual mice as same color
function tpr_fpr_scatter2(x,y,size,clrMp,titleStr,dp,c,dp0,c0)
% x  x data (cell array of array of nums) (FPR)
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
dCurve = plot_isosensitivity(mean(dp),'LIME');
cCurve = plot_isobias(mean(c),'LIGHTCORAL');
dCurve0 = plot_isosensitivity(mean(dp0),'DARKTURQUOISE');
cCurve0 = plot_isobias(mean(c0),'LIGHTSALMON');
scatPlots = [];
for i = 1:length(x)
    % can modify for 'filled',mkr etc.
    s = scatter(x{i},y{i},size,clrMp(i,:),'filled');
    scatPlots = [scatPlots s];
    ellipse(calcSE(x{i}),calcSE(y{i}),0,mean(x{i}),mean(y{i}),clrMp(i,:));
    scatter(mean(x{i}),mean(y{i}),size*2,'Marker','*','MarkerEdgeColor',clrMp(i,:));
%     p = polyfit(x{i},y{i},2);
%     x2 = 0:0.01:1;
%     y2 = polyval(p,x2);
%     plot(x2,y2,'Color',clrMp(i,:));
end
hold off;
xlabel('FPR');
ylabel('TPR');
title(titleStr);
sem_dp = calcSE(dp);
sem_c = calcSE(c);
sem_dp0 = calcSE(dp0);
sem_c0 = calcSE(c0);
legend([[dCurve, cCurve dCurve0 cCurve0] scatPlots],...
    {['d'': ' num2str(round(mean(dp),2)) ', SEM: ' num2str(round(sem_dp,2))],...
    ['c: ' num2str(round(mean(c),2)) ', SEM: ' num2str(round(sem_c,2))],...
    ['d'' Early: ' num2str(round(mean(dp0),2)) ', SEM: ' num2str(round(sem_dp0,2))],...
    ['c Early: ' num2str(round(mean(c0),2)) ', SEM: ' num2str(round(sem_c0,2))],...
    'Early','Mid','Late','Last 50 Trials'},'Location', 'bestoutside');
% newHandle = copyobj(l1,[dCurve,cCurve]);
% legend(scatPlots,{'Early','Mid','Late'},'Location','BestOutside');
hold off;
end