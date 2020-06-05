% Author: QZ
% 06/27/2019
function plotCorr_QZ(yLab,xLab,titleStr,x,y,yLimBool,reverse,labelDots,dotLabels)
hold on
hold on
if yLimBool
    ylim([-1,1]);
end
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
ylabel(yLab);
xlabel(xLab)
title(titleStr);
scatter(x,y);
[fittedX,fittedY,cor,pval,m,~] = corrReg(x,y);
l = plot(fittedX,fittedY,'DisplayName',['r=' num2str(cor) ', pval=' num2str(pval) ', m=' num2str(m)]);
legend(l,'Location','Best');
hold off
hold off
end