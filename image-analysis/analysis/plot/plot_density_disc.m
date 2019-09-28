function plot_density_disc(dat, names)
n = length(dat);
colors = {'b', 'g', 'r', 'm', 'c', 'y', 'k'};
hold on;
for b=1:n
    datum = dat{b};
    set = min(datum):max(datum);
    points = zeros(length(set),2);
    for i=1:length(set)
        val = set(i);
        points(i,:) = [val sum(datum(:) == val)];
    end
    
    plot(points(:,1), points(:,2), ['-*' colors{b}]);
end

for b=1:n
    vline(mean(dat{b}), colors{b});
end
legend(names);
end

