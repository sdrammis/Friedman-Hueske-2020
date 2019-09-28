function plotbars(dat, names, colors, varargin)
jitterIdx = find(strcmp('jitter', varargin));

n = length(dat);
hold on;
for i = 1:n
    datum = dat{i};
    datum = datum(datum ~= Inf);
    
    if ~isempty(jitterIdx)
        a = varargin{jitterIdx + 1};
        b = -a;
        datum = datum + a + (b-a).*rand(length(datum),1);
        xs = -0.25 + (0.5).*rand(length(datum),1);
    else
        xs = zeros(length(datum),1);
    end
    
    bar(i, nanmean(datum), 'FaceColor',  colors(i,:));
    if isempty(varargin) || ~contains(varargin, 'nodots')
        scatter(xs' + ones(1,length(datum))*i, datum, 'k*');
    end
end
ploterr(1:n, cellfun(@nanmean, dat), [], cellfun(@utils.std_error, dat) , 'k.', 'abshhxy', 0);
set(gca, 'xtick', 1:n, 'xticklabel', names);
end
