% Author: QZ
% 06/11/2019
% NOTE: make sure that NaNs are accounted for!
function plotBar(barYData,yLab,xLab,titleStr)
% param1  barYData  the y data. Input in a cell array of the form 
%                   {[youngWT.RewardLicksStart],...}
% param2  yLab  string that is the y label
% param3  xLab  a cell array of strings, in corresponding order to barYData
% param4  titleStr  a string that will be the title for this plot/subplot
% plots a bar graph with error bars and text upon each bar
title(titleStr);
ylabel(yLab);
y = [];
err = [];
textLabs = {};
for i = 1:length(barYData)
    datCol = barYData{i};
    y = [y nanmean(datCol)];
    err = [err calcSE(datCol)];
%     textLabs{i} = ['n=',num2str(length(datCol))];
    textLabs{i} = num2str(nanmean(datCol));
end
% plotting
bar(y);
set(gca,'XTickLabel',xLab,'XTick',1:numel(xLab));
xtickangle(45);
xt = get(gca,'XTick');
% scatter and text label
for i = 1:numel(xLab)
    text(xt(i),y(i),textLabs{i},'horiz','center','vert','bottom');
    dat = barYData{i};
    scatter(repmat(xt(i),length(dat),1),dat,'MarkerEdgeColor','m');
end
hold on;
errorbar(y,err,'k','linestyle','none');
hold off;
end