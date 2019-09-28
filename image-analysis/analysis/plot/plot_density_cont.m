function plot_density_cont(dat, names)
n = length(dat);
colors = {'b', 'g', 'r', 'm', 'c', 'y', 'k'};
hold on;
for b=1:n
    datum = dat{b};
    [vals, edges] = histcounts(datum);
    xs = edges(1:end-1) + (diff(edges)/2);
    
    plot(xs, vals, ['-*' colors{b}]);
end

for b=1:n
    vline(mean(dat{b}), colors{b});
end
legend(names);
end

