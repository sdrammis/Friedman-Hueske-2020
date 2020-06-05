function raster(spikes, edges, trial_num)
n = length(spikes);
for ii=1:n
y = n - trial_num(ii) + 1;
row_spikes = spikes{ii};

if ~isempty(edges)
    rx = edges(ii,1);
    ry = y - 0.25;
    rw = edges(ii,2) - edges(ii,1);
    rh = .5;

    hold on;
    p = patch([rx,rx,rx+rw,rx+rw], [ry,ry+rh,ry+rh,ry],[1 0 0]);
    p.EdgeColor = 'none';
    hold off;
    alpha(p, 0.25);
end


hold on;
scatter(row_spikes, y * ones(1,length(row_spikes)), 5, 'k', 'filled');
end
end

