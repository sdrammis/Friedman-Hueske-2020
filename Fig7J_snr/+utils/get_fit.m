function [fitobj,gof] = get_fit(x,y)
% Start Fitting to linear line or sigmoid function, and get rsquare error
fitType = fittype('a+(b-a)/(1+exp(c-d*x))', 'independent', 'x', 'dependent', 'y');
opts = fitoptions( 'Method', 'NonlinearLeastSquares');
opts.StartPoint = [1 0 5 1];
opts.Display = 'Off';
[fitobj,gof] = fit(x,y,fitType,opts);
end

