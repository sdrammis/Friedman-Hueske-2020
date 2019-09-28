function plot_bars(dat, names, varargin)
idx = find(strcmp('jitter', varargin));

if ~isempty(idx)
    a = varargin{idx + 1};
    b = -a;
    dat = cellfun(@(x) x + a + (b-a).*rand(length(x),1), dat, 'UniformOutput', false);
    xs = cellfun(@(x) -0.25 + (0.5).*rand(length(x),1), dat, 'UniformOutput', false);
else
    xs = cellfun(@(x) zeros(length(x),1), dat, 'UniformOutput', false);
end


n = length(dat);
colors = cbrewer('qual', 'Set1', 10);
hold on;
for b = 1:n
    datum = dat{b};
    bar(b, nanmean(datum), 'FaceColor',  colors(b,:));
    scatter(xs{b}' + ones(1,length(datum))*b, datum, 'k*');
end
ploterr(1:n, cellfun(@nanmean, dat), [], cellfun(@std_error, dat) , 'k.', 'abshhxy', 0);
set(gca, 'xtick', 1:n, 'xticklabel', names);
end

