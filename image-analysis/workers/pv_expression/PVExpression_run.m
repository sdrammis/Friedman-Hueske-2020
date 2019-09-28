function PVExpression_run(exid, imgSrc, realsize, ~, ~, doneDir, cellsDataFile)
img = imread(imgSrc);
data = load(cellsDataFile);

imsize = size(img);
realdensity = imsize(1)*imsize(2)/realsize;

cellsMask = data.cells;
cellsMask(~data.striatumMask) = 0;

cellBodies = img;
cellBodies(~cellsMask) = 0;

histo = imhist(cellBodies);
histo = histo(2:255);
thresholds = find(histo>0);
threshold = 0.2 * mean(thresholds);

imgExpr = img >= threshold;
striatumExpr = imgExpr;
striatumExpr(~data.striatumMask) = 0;
[striatumExprMedial, striatumExprCentral, striatumExprLateral, ...
    medialMask, centralMask, lateralMask] = split_quadrants(striatumExpr);

sumMedialExpr = sum(sum(striatumExprMedial));
sumCentralExpr = sum(sum(striatumExprCentral));
sumLateralExpr = sum(sum(striatumExprLateral));

medialMaskArea = sum(sum(bitand(data.striatumMask,medialMask)));
centralMaskArea = sum(sum(bitand(data.striatumMask,centralMask)));
lateralMaskArea = sum(sum(bitand(data.striatumMask,lateralMask)));

medialExprPerct = sumMedialExpr / medialMaskArea;
centralExprPerct = sumCentralExpr / centralMaskArea;
lateralExprPerct = sumLateralExpr / lateralMaskArea;

medialExprMM2 = sumMedialExpr / (medialMaskArea / realdensity);
centralExprMM2 = sumCentralExpr / (centralMaskArea / realdensity);
lateralExprMM2 = sumLateralExpr / (lateralMaskArea / realdensity);

overalExprPerct = sum(sum(striatumExpr)) / sum(sum(data.striatumMask));
overalExprMM2 = sum(sum(striatumExpr)) / (sum(sum(data.striatumMask)) / realdensity);

save(sprintf('%s/%s-data.mat', doneDir, exid), 'striatumExpr', ...
    'medialExprPerct', 'centralExprPerct', 'lateralExprPerct', 'overalExprPerct', ...
    'medialExprMM2', 'centralExprMM2', 'lateralExprMM2', 'overalExprMM2', '-v7.3');
end

