% Author: QZ
% 07/11/2019
function nanIds = plotCorrROC3_QZ(x,y,titleStr,xLab,yLab,reverse,plotNames,...
    markerSymbols,markerColors,lineColors,labCases,cases,saveAndClose,subFolderName)
% plots all traces
% titleStr :: string
% yLimBool, reverse, colAges ::  booleans
% xLab, yLab ::  cell array of 4 strings (1 for each subplot)
% y :: cell array of 4 cell arrays of 2 arrays {2 rTAs,2 r+cs,2 rTS,2 cTS}
% cases :: cell array of certain number of cells (1 for each correlation)
% x, ages :: cell arrays of certain number of arrays (1 for each correlation)
% e.g. for WT vs HD traces vs. C, x = {cWT cHD}
% plotNames, markerSymbols, markerColors :: cell array of same length as 
% each cell array in x/y, e.g. {'WT','HD'}, {'r','b'}
figure();
nanIds = cell(1,length(x));
    hold on
    ylabel(yLab);
    xlabel(xLab)
    title(titleStr);
    legendLabs = cell(1,length(x));
    plots = zeros(1,length(x));
    for j = 1:length(x)
        hold on
        [this_x,this_y,nanIdxs,this_cases] = nanFilter_QZ(x{j},y{j},cases{j});
        nanIds{j} = [nanIds{j} nanIdxs];
        l = plotCorr_QZ(this_x,this_y,reverse,labCases,this_cases,plotNames{j},...
            markerSymbols{j},markerColors{j},lineColors{j});
        legendLabs{j} = get(l,'DisplayName');
        plots(j) = l;
        hold off
        clear this_x this_y
    end
    legend(plots,legendLabs,'Location','Best')
    hold off
if saveAndClose
%     figName = titleStr;
%     saveas(figure(),[pwd '/startEndFigures/' figName '.fig']);
    savefig([pwd '/' subFolderName '/' titleStr '.fig']);
    close all
end
end