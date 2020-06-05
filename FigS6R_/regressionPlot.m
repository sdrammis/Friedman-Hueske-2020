function regressionPlot(input1, input2)

x = cell2mat(input1);
y = cell2mat(input2);
badIDx = [];
for i = 1:length(x)
    if isnan(x(i))
       badIDx = [badIDx, i];
    end
end
x(badIDx) = [];
y(badIDx) = [];

[~,m1,b1]=regression(x,y);
fittedX=(min(x)-0.01):0.01:(max(x)+0.01);
fittedY=fittedX*m1+b1;
cor1 = corr2(x,y);
[~,P] = corrcoef(x,y); %P-value
if length(P) > 1
    pval= P(2);
else
    pval = P;
end


fitpoly2 = fit(x.', y.', 'poly1')
         
figure
plot(fitpoly2, x.', y.')
title('All Matrix Mice First 200 Trials')
ylabel('Integral of vGlut Max Intensity CDF From 8-14')
xlabel('Reward Trace Sum - Cost Trace Sum ')
r = regression(x, y)
pval

% t = table(x.',y.')
% %S = load(t)
% beta0 = t.beta
% [~, nonLinR] = nlinfit(x, y, @hougen, beta0)
