% Author: QZ
% 06/27/2019
function l = plotCorr_QZ(x,y,reverse,labelDots,dotLabels,plotName,...
    markerSymbol,markerColor,lineColor)
hold on
hold on
% if yLimBool
%     ylim([-1,1]);
% end
if reverse
    set(gca,'xdir','reverse');
end
if labelDots
    if reverse
        dx = -0.1;
        dy = -0.1;
    else
        dx = 0.1;
        dy = 0.1;
    end
    text(x+dx,y+dy,dotLabels,'Fontsize', 10);
end
% ylabel(yLab);
% xlabel(xLab)
% title(titleStr);
    scatter(x,y,'Marker',markerSymbol,'MarkerEdgeColor',markerColor);
[fittedX,fittedY,cor,pval,m,~] = corrReg(x,y);
l = plot(fittedX,fittedY,'Color',lineColor,'DisplayName',...
    [plotName ': r=' num2str(cor) ', pval=' num2str(pval) ', m=' num2str(m)]);
% legend(l); % 'Location','Best');
hold off
hold off
end