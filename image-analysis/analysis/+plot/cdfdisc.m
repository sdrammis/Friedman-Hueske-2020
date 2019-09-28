function cdfdisc(dat, names, colors)
n = length(dat);
hold on;
for b=1:n
    datum = dat{b};
    set = min(datum):max(datum);
    points = zeros(length(set),2);
    for i=1:length(set)
        val = set(i);
        points(i,:) = [val (sum(datum(:) <= val) / length(datum))];
    end
    
    plot(points(:,1), points(:,2), '-*', 'Color', colors(b,:));
end

legend(names);
end

