n = height(vglutexprLWT);

meanStrioNL = nanmean(vglutexprNLHD.strio);
stdStrioNL = nanstd(vglutexprNLHD.strio);
meanMatrixNL = nanmean(vglutexprNLHD.matrix);
stdMatrixNL = nanstd(vglutexprNLHD.matrix);

learnedTrial = zeros(1, n);
strioExpr = zeros(1, n);
matrixExpr = zeros(1, n);

for i=1:n
    mouseSlice = char(vglutexprLWT.slice(i));
    [s,t] = regexp(mouseSlice, "[0-9]+_(region|slice)");
    split = strsplit(mouseSlice(s:t), '_');
    
    mouseID = split{1};
    
    learnedTrial(i) = first(twdb_lookup(miceType, 'learnedFirstTask', 'key', 'ID', mouseID));
    strioExpr(i) = vglutexprLWT.strio(i);
    matrixExpr(i) = vglutexprLWT.matrix(i);
end

x = learnedTrial;
y1 = strioExpr;
y2 = matrixExpr;
y3 = strioExpr ./ matrixExpr;

[r1, p1] = corrcoef(x,y1);
[r2, p2] = corrcoef(x,y2);
[r3, p3] = corrcoef(x,y3);
r1 = r1(1,2);
p1 = p1(1,2);
r2 = r2(1,2);
p2 = p2(1,2);
r3 = r3(1,2);
p3 = p3(1,2);

pf1 = polyfit(x, y1, 1);
pv1 = polyval(pf1, x);
pf2 = polyfit(x, y2, 1);
pv2 = polyval(pf2, x);
pf3 = polyfit(x, y3, 1);
pv3 = polyval(pf3, x);

figure;

subplot(2, 1, 1);
scatter(x, y1, 'xb')
hold on;
plot(x, pv1, '-b');
hold on
scatter(x, y2, 'xr');
hold on;
plot(x, pv2, '-r');
hold on;
hline(meanStrioNL, '-k');
hold on;
hline(meanStrioNL - stdStrioNL, '--k');
hold on;
hline(meanStrioNL + stdStrioNL, '--k');
legend('Strio Slices', 'Strio Best Fit', 'Matrix Slices', 'Matrix Best Fit');
ylabel('VGlut Expression');
xlabel('Learned Trial');
title(['VGlut Expression, ' ...
    sprintf('Strio r=%.2f p=%.3f', r1, p1) ', ' ...
    sprintf('Matrix r=%.2f p=%.3f', r2, p2)]);

subplot(2, 1, 2);
scatter(x, y3);
hold on;
plot(x, pv3);
ylabel('VGlut Expression');
xlabel('Learned Trial');
title(['VGlut Expression, ' ...
    sprintf('Strio / Matrix r=%.2f p=%.3f', r3, p3)]);
