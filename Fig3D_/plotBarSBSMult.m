% Author: QZ
% 06/19/2019
function plotBarSBSMult(yDat,yLab,xLab,titleStr,legLab)
% yDat  cell array of cell arrays of arrays. Each cell array in this cell
%       array must contain the same number of arrays!
%       e.g. {{[1 2],[4 7 1 2],[]},{[1],[6 4 1 2 7 2 4 7],[]}}
% yLab  string that will be the y axis label
% xLab  cell array of strings of x labels. Should be same as the length of
%       each cell array in the cell array
% titleStr  string that will be the title of the graph
% legLab  cell array of legend labels, equal to length of each cell array
%         in yDat
% plots side-by-side bar plots
title(titleStr);
ylabel(yLab);
y = zeros(length(yDat{1}),length(yDat));
err = zeros(length(yDat{1}),length(yDat));
textLabs = cell(length(yDat{1}),length(yDat));
for i = 1:length(yDat) % 2 bars per group
    for j = 1:length(yDat{i}) % 3 groups total
        y(j,i) = mean(yDat{i}{j});
        err(j,i) = calcSE(yDat{i}{j});
        textLabs{j,i} = ['n=',num2str(length(yDat{i}{j}))];
    end
end
a = bar(y);
set(gca,'XTickLabel',xLab,'XTick',1:length(xLab));
xtickangle(45);
pause(0.1);
% add error bars
numGroups = size(y,1);
numBars = size(y,2); % number of bars in each group
groupWidth = min(0.8, numBars/(numBars + 1.5));
offsets = [a.XOffset];
hold on;
for j = 1:numBars % e.g. 2
    % Calculate center of each bar
    x = (1:numGroups) + offsets(j);
    errorbar(x, y(:,j), err(:,j), 'k', 'linestyle', 'none');
    % text label
    text(x,y(:,j),textLabs(:,j),'horiz','center','vert','bottom');
    pause(0.05);
    % scatter
    yCurrent = yDat{j};
    for k = 1:length(xLab) % e.g. 3
        xCurrent = zeros(1,length(yCurrent{k})) + x(k);
        clrMp = jet(length(xCurrent));
%         scatter(xCurrent,yCurrent{k},'MarkerEdgeColor','m');
        for l = 1:length(xCurrent)
            scatter(xCurrent(l),yCurrent{k}(l),'MarkerEdgeColor',clrMp(l,:));
        end
        pause(0.05); 
    end
end
% % add lines
% for i = 1:length(xLab) % 4 groups
%     x_this = i*ones(1,length(offsets)) + offsets;
%     for j = 1:length(yDat)
%         y_this = yDat{j}{i};
%         plot(x_this,y_this,'m-');
%     end
% end
legend(a,legLab,'Location','BestOutside'); % maybe get rid of a
hold off;
end