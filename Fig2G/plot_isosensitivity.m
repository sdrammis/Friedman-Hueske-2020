function [curve] = plot_isosensitivity(dp2plot)
% Plot isosensitivity curve i.e. curve of all FPR, TPR pairs that give a certain 
% selectivity (d-prime) 
%
% Input  :: d2plot - specific (d') to plot
% Output :: curve  - handle on plot object

    x = 0.01:0.001:0.99;
    dp = bsxfun(@minus, norminv(x)', norminv(x));
    tol = 0.001;
    idx = find(dp > dp2plot - tol & dp < dp2plot + tol);
    [yi, xi] = ind2sub(size(dp), idx);
    curve = plot(x(xi), x(yi), 'LineWidth', 1.2, 'Color', rgb('BLACK'));
    xlim([0 1])
    ylim([0 1])
end