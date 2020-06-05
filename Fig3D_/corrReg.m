function [fittedX,fittedY,cor,pval,m1,b1] = corrReg(x,y)
% Sebastian's code start
[~,m1,b1]=regression(x,y);
fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
fittedY=fittedX*m1+b1;
cor = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval = P(2);
else
    pval = P;
end
% Sebastian's code end
end