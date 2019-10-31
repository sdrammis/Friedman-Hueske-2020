% Author: QZ
% 06/11/2019
% NOTE: make sure that NaNs are accounted for!
function plotNoBar_UPDATE2(barYData,yLab,xLab,titleStr,clrStr,txtClr,lnClr,scttr,labTxt)
% param1  barYData  the y data. Input in a cell array of the form 
%                   {[youngWT.RewardLicksStart],...}
% param2  yLab  string that is the y label
% param3  xLab  a cell array of strings, in corresponding order to barYData
% param4  titleStr  a string that will be the title for this plot/subplot
% param5  clrStr  string/RGB triple indicating the color of the markers e.g. 'c'
% param6  txtClr  string/RGB triple indicating the color of the text
% param7  lnClr  string/RGB triple indicating the color of the line
% param8  scttr  boolean, whether or not to scatter
% plots a bar graph with error bars and text upon each bar
title(titleStr);
ylabel(yLab);
xlim([0,length(barYData)+1]);
y = [];
err = [];
textLabs = {};
for i = 1:length(barYData)
    datCol = barYData{i};
    y = [y nanmean(datCol)];
    err = [err calcSE(datCol)];
    if labTxt
        textLabs{i} = ['n=',num2str(length(datCol))];
    end
end
% plotting
set(gca,'XTickLabel',xLab,'XTick',1:numel(xLab));
xtickangle(45);
xt = get(gca,'XTick');
% scatter and text label
for i = 1:numel(xLab)
    if labTxt
        text(xt(i),y(i),textLabs{i},'horiz','center','vert','bottom','color',txtClr);
    end
    dat = barYData{i};
    if scttr == true
        scatter(repmat(xt(i),length(dat),1),dat,'MarkerEdgeColor',clrStr);
    end
end
hold on;
errorbar(y,err,lnClr);
hold off;
end