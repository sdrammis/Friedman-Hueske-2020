function plot_roc(t, f, d, c, varargin)
%PLOT_ROC Plot ROC points and curves
% Generate N subplots of ROCs. For each subplot i in range N, plot K (FPR,
% TPR) pairs given in ith rows of t and f; an isosensitivity curve for 
% d-prime given in d(i); and an isobias vurve for c given in c(i). Can edit
% which of the above features get graphed with varargin (see below).
%
% Input :: t - N x K matrix of true-positive rates 
%          f - N x K matrix of false-positive rates
%          d - length-N vector of d-prime values
%          c - length-N vector of c values
%          varargin -
%               (1) mouse_type  - string to put in title; i.e. "WT"; defaults "N/A"
%               (2) plot_points - bool to plot (FPR, TPR) pairs; defaults true
%               (3) plot_d - bool to plot isosensitivity curve; defaults true
%               (4) plot_c - bool to plot isobias curve; defaults true

    n_mice = size(t, 2);
    
    plot_points_index = find(strcmp('PlotPoints', varargin), 1);
    if ~isempty(plot_points_index)
        plot_points = varargin{plot_points_index(1) + 1};
    else
        plot_points = true;
    end
    
    plot_d_index = find(strcmp('PlotD', varargin), 1);
    if ~isempty(plot_d_index)
        plot_d = varargin{plot_d_index(1) + 1};
    else
        plot_d = true;
    end
    
    plot_c_index = find(strcmp('PlotC', varargin), 1);
    if ~isempty(plot_c_index)
        plot_c = varargin{plot_c_index(1) + 1};
    else
        plot_c = true;
    end

    sem_d_index = find(strcmp('SEMD', varargin), 1);
    if ~isempty(sem_d_index)
        sem_d = varargin{sem_d_index(1) + 1};
    else
        sem_d = 1;
    end
    
    sem_c_index = find(strcmp('SEMC', varargin), 1);
    if ~isempty(sem_c_index)
        sem_c = varargin{sem_c_index(1) + 1};
    else
        sem_c = NaN;
    end
    
    colored_points_index = find(strcmp('ColoredPoints', varargin), 1);
    if ~isempty(colored_points_index)
        colored_points = varargin{colored_points_index(1) + 1};
    else
        colored_points = true;
    end
    
    if colored_points
        colors = get_colors(n_mice);
    end
    
    % Plot
    hold on

    % Plot selectivity
    if plot_d
        plot([0 1], [0 1], 'k--')                   % Random chance, d' = 0
        d_curve = plot_isosensitivity(d);
    end

    % Plot bias
    if plot_c
        plot([0 1], [1 0], 'k--')                   % No bias, c = 0
        c_curve = plot_isobias(c);
    end
    
    % Plot data
    if plot_points
        for i = 1:n_mice
            t2plot = t(i);
            f2plot = f(i);

            if colored_points
                color = colors{i};
                plot(f2plot{:}, t2plot{:}, 'o', 'MarkerFaceColor', color, 'MarkerEdgeColor', color);
            else
                plot(f2plot{:}, t2plot{:}, 'k*');
            end
        end
    end

    xlabel('FPR')
    ylabel('TPR')

    if plot_d && plot_c
        legend([d_curve, c_curve], {['d'': ' num2str(round(d, 2)) ', SEM: ' num2str(round(sem_d, 2))], ['c: ' num2str(round(c, 2)) ', SEM: ' num2str(round(sem_c, 2))]}, 'Location', 'east')
    elseif plot_d
        legend([d_curve], {['d'': ' num2str(round(d, 2)) ', SEM: ' num2str(round(sem_d, 2))]}, 'Location', 'east')
    elseif plot_c
        legend([c_curve], {['c: ' num2str(round(c, 2)) ', SEM: ' num2str(round(sem_c, 2))]}, 'Location', 'east')
    end

    legend('show')
end

