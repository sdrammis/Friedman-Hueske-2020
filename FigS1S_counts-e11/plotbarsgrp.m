function plotbarsgrp(dat, names)
m = [];
e1 = [];
e2 = [];

n = length(dat{1});
hold on;
for i = 1:n
    datum1 = dat{1}{i};
    datum2 = dat{2}{i};

    datum1 = datum1(datum1 ~= Inf);
    datum2 = datum2(datum2 ~= Inf);
    
    m = [m; nanmean(datum1) nanmean(datum2)];
    e1 = [e1; std_error(datum1)];
    e2 = [e2; std_error(datum2)];
end
b = bar(m);
pause(0.01);
x1 = b(1).XData + b(1).XOffset;
x2 = b(2).XData + b(2).XOffset;
ploterr(x1, m(:,1), [], e1, 'k.', 'abshhxy', 0);
ploterr(x2, m(:,2), [], e2, 'k.', 'abshhxy', 0);

for i=1:n
    datum1 = dat{1}{i};
    datum2 = dat{2}{i};
    datum1 = datum1(datum1 ~= Inf);
    datum2 = datum2(datum2 ~= Inf);
    scatter(ones(1,length(datum1))*x1(i), datum1, 'k*');
    scatter(ones(1,length(datum2))*x2(i), datum2, 'k*');
end
set(gca, 'xtick', 1:n, 'xticklabel', names);
end
