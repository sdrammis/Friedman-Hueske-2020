function plotCorrZ(miceIDs,x_overall,y_overall,xLab,yLab,xbin_size,mouseInfo)
figure()
begin = round(min(x_overall),1)-0.1;
if rem(begin,xbin_size)
    begin = begin-0.1;
end
ending = round(max(x_overall),1)+0.1;
if rem(ending,xbin_size)
    ending = ending+0.1;
end
x = begin:xbin_size:ending;
byX = cell(1,length(x)-1);
for n=1:length(x)-1
    byX{n} = [byX{n} y_overall(and(x_overall<x(n+1),x_overall>=x(n)))];
end
%Parameters for Striosomal Z-scores
y = cellfun(@nanmean,byX); %Z-Score mean per bin
y_std = cellfun(@nanstd,byX); %Z-score STD per bin
len = cellfun(@length,byX); %Amount of datapoints per bin
%Removes bins w/o datapoints
thresh = 1;
x = x(len>thresh);
y = y(len>thresh);
y_std = y_std(len>thresh);
len = len(len>thresh);
y_err = y_std./sqrt(len);

%For amount of datapoints
color_str = {[1 1 0],[1 0.5 0],[1 0 0]};
%Linear Regression and Correlation
[~,m1,b1]=regression(x,y);
% fittedX=min(x-x_error):0.01:max(x_error+x);
fittedX1=(min(x)-0.01):0.01:(max(x)+0.01);
fittedY1=fittedX1*m1+b1;
cor1 = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval1 = P(2);
else
    pval1 = P;
end
% 
% subplot(2,1,2)
hold on
plot(fittedX1+(xbin_size/2),fittedY1,'k','LineWidth',3);%Plots line of best fit
errorbar(x+(xbin_size/2),y,y_err,'.k')
for n=1:length(x)%Plots each point indicating amount of datapoints per bin
    if floor(log10(len(n))+1)==1
        p(1) = plot(x(n)+(xbin_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
    elseif floor(log10(len(n))+1)==2
        p(2) = plot(x(n)+(xbin_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
    elseif floor(log10(len(n))+1)==3
        p(3) = plot(x(n)+(xbin_size/2),y(n),'ko','MarkerSize',floor(log10(len(n))+1)*4,'MarkerFaceColor',color_str{floor(log10(len(n))+1)});
    end
end

xlabel(xLab)
ylabel(yLab)
title({[mouseInfo ' NumMice=' num2str(length(miceIDs)) ' Mean of Bins, Bin Size = ' num2str(xbin_size)],...
    ['Pearson Corr Coef = ' num2str(cor1) ' / Slope = ' num2str(m1) ' / P-Val = ' num2str(pval1)]})
axis tight
hold off
disp([mouseInfo ' Bin Size = ' num2str(xbin_size) ' r=' num2str(cor1) ' Slope= ' num2str(m1) ' p=' num2str(pval1)])
end