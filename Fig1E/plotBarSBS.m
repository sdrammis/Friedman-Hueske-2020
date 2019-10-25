% Author: QZ
% 06/12/2019
function plotBarSBS(yDat1,yDat2,yLab,xLab,titleStr)
% yDat1  cell array of data arrays
% yDat2  cell array of data arrays, MUST be same length as yDat1
% yLab  string that will be the y axis label
% xLab  cell array of strings of x labels. Should be the length of yDat1
%       and yDat2
% titleStr  string that will be the title of the graph
% plots side-by-side bar plots

title(titleStr);
ylabel(yLab);
y1 = [];
y2 = [];
err1 = [];
err2 = [];
textLabs1 = {};
textLabs2 = {};
for i = 1:length(yDat1)
    y1 = [y1 mean(yDat1{i})];
    err1 = [err1 calcSE(yDat1{i})];
    textLabs1{i} = ['n=',num2str(length(yDat1{i}))];
    y2 = [y2 mean(yDat2{i})];
    err2 = [err2 calcSE(yDat2{i})];
    textLabs2{i} = ['n=',num2str(length(yDat2{i}))];
end
y = [y1;y2]';
textLabs = {textLabs1;textLabs2}';
a = bar(y);
set(gca,'XTickLabel',xLab,'XTick',1:length(xLab));
pause(0.1);
err = [err1;err2]';
% add error bars
numGroups = size(y,1);
numBars = size(y,2); % number of bars in each group
groupWidth = min(0.8, numBars/(numBars + 1.5));
offsets = [a.XOffset];
hold on;
for j = 1:numBars
    % Calculate center of each bar
    x = (1:numGroups) + offsets(j);
    errorbar(x, y(:,j), err(:,j), 'k', 'linestyle', 'none');
    % scatter and text label
    text(x,y(:,j),textLabs{j},'horiz','center','vert','bottom');
    pause(0.05);
    % scatter is wrong - will work on this later. Prob need nested for :(
    % scatter(x,y(:,j),'MarkerEdgeColor','m');
    % pause(0.05);
end
hold off;
legend('Start','After','Location','BestOutside');
hold off;
end