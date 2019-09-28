idxs = ~cellfun(@isempty, {analysisdb(:).msnStrioDensities}) ...
    | ~cellfun(@isempty, {analysisdb(:).msnMatrixDensities});
rows = analysisdb(idxs);

strioMASH = makegroup(micedb, rows, 'Strio', 'MASH');
strioDLX = makegroup(micedb, rows, 'Strio', 'DLX');
matrixMASH = makegroup(micedb, rows, 'Matrix', 'MASH');
matrixDLX = makegroup(micedb, rows, 'Matrix', 'DLX');

[datsStrioMASH, datmStrioMASH] = getdata(strioMash);
[datsStrioDLX, datmStrioDLX] = getdata(strioDLX);
[datsMatrixMASH, datmMatrixMASH] = getdata(matrixMASH);
[datsMatrixDLX, datmMatrixDLX] = getdata(matrixDLX);

figure;
subplot(2,2,1);
plot.plotbars(...
    {datsStrioMASH(:,1),datmStrioMASH(:,1) }, ...
    {'Strio Density', 'Matrix Density'});
title('Strio MASH');
subplot(2,2,2);
plot.plotbars(...
    {datsStrioDLX(:,1),datmStrioDLX(:,1) }, ...
    {'Strio Density', 'Matrix Density'});
title('Strio DLX');
subplot(2,2,3);
plot.plotbars(...
    {datsMatrixMASH(:,1),datmMatrixMASH(:,1) }, ...
    {'Strio Density', 'Matrix Density'});
title('Matrix MASH');
subplot(2,2,4);
plot.plotbars(...
    {datsMatrixDLX(:,1),datmMatrixDLX(:,1) }, ...
    {'Strio Density', 'Matrix Density'});
title('Matrix DLX');

function [datStrio, datMatrix] = getdata(group)
datStrio = reshape([group.msnStrioDensities],[],7);
datStrio(datStrio == Inf) = NaN;
datMatrix = reshape([group.msnMatrixDensities],[],7);
datMatrix(datMatrix == Inf) = NaN;
end

function group = makegroup(micedb, rows, striosomality, mashOrDlxity)
group = [];

for i=1:length(rows)
    row = rows(i);
    mouseID = row.mouseID;
    
    mashOrDlx = isMashOrDlx(mouseID);
    if isempty(mashOrDlx)
        continue;
    end
    
    mouse = micedb(strcmp(mouseID, {micedb(:).ID}));
    if mouse.histologyStriosomality == 0
        continue;
    end
    
    if strcmp(mouse.intendedStriosomality, striosomality) ...
            && strcmp(mashOrDlx, mashOrDlxity)
        group = [group row];
    end
end
end

function ret = isMashOrDlx(mouseid)
MASH = {'2703', '2712', '2713', '2788', '2791', '2778', '2740', '2744', ...
    '2745', '2833', '2784', '2783', '2787', '2834', '2593', '2594', '2831', ...
    '3762', '2795', '2588', '2553', '2775', '2774', '4944', '4947', '2826', ...
    '2841', '2824', '2830'};
DLX = {'2705', '2660', '2803', '2610', '2735', '3758', '2734'};

ret = [];
if any(strcmp(mouseid, MASH))
    ret = 'MASH';
elseif any(strcmp(mouseid, DLX))
    ret = 'DLX';
end
end
