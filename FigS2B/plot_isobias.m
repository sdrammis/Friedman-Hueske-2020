function [curve] = plot_isobias(c2plot,colorStr)
% Plot isobias curve i.e. curve of all FPR, TPR pairs that give a certain 
% reponse bias (c) 
%
% Input  :: c2plot - specific (c) to plot
% Output :: curve  - handle on plot object

    x = 0.01:0.001:0.99;
    c = bsxfun(@(t, f) -0.5 * (t + f), norminv(x)', norminv(x));
    tol = 0.001;
    idx = find(c > c2plot - tol & c < c2plot + tol);
    [yi, xi] = ind2sub(size(c), idx);
    curve = plot(x(xi), x(yi), 'LineWidth', 1.2, 'Color', rgb(colorStr));% originally rgb('LIGHTCORAL')
    xlim([0 1])
    ylim([0 1])
end