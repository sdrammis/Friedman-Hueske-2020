% groupsMatrixMash4 = groupmice4(micedb, 'Matrix', 'Mash');
% groupsMatrixDlx4  = groupmice4(micedb, 'Matrix', 'Dlx');
% groupsStrioMash4  = groupmice4(micedb, 'Strio', 'Mash');
% groupsStrioDlx4   = groupmice4(micedb, 'Strio', 'Dlx');
% 
% groupsStrioMash2 = groupmice2(micedb, 'Strio', 'Mash');
% groupsStrioDlx2  = groupmice2(micedb, 'Strio', 'Dlx');
% groupsMatrixMash2 = groupmice2(micedb, 'Matrix', 'Mash');
% groupsMatrixDlx2 = groupmice2(micedb, 'Matrix', 'Dlx');
% 
% [datStrioMashPVMSN, nStrioAnimalsMashPVMSN] = ...
%     cellfun(@(group) getgroupdata_pvmsn(analysisdb, group), groupsStrioMash4, 'UniformOutput', false);
% [datStrioDlxPVMSN, nStrioAnimalsDlxPVMSN] = ...
%     cellfun(@(group) getgroupdata_pvmsn(analysisdb, group), groupsStrioDlx4, 'UniformOutput', false);
% [datMatrixMashPVMSN, nMatrixAnimalsMashPVMSN] = ...
%     cellfun(@(group) getgroupdata_pvmsn(analysisdb, group), groupsMatrixMash4, 'UniformOutput', false);
% [datMatrixDlxPVMSN, nMatrixAnimalsDlxPVMSN] = ...
%     cellfun(@(group) getgroupdata_pvmsn(analysisdb, group), groupsMatrixDlx4, 'UniformOutput', false);
% 
% [datMatrixMashSpines, nMatrixAnimalsMashSpines] = ...
%     cellfun(@(group) getgroupdata_spines(analysisdb, group, 'slice'), groupsMatrixMash2, 'UniformOutput', false);
% [datMatrixDlxSpines, nMatrixAnimalsDlxSpines] = ...
%     cellfun(@(group) getgroupdata_spines(analysisdb, group, 'slice'), groupsMatrixDlx2, 'UniformOutput', false);
% [datStrioMashSpines, nStrioAnimalsMashSpines] = ...
%     cellfun(@(group) getgroupdata_spines(analysisdb, group, 'slice'), groupsStrioMash2, 'UniformOutput', false);
% [datStrioDlxSpines, nStrioAnimalsDlxSpines] = ...
%     cellfun(@(group) getgroupdata_spines(analysisdb, group, 'slice'), groupsStrioDlx2, 'UniformOutput', false);
% 
% mash = {...
%     datStrioMashPVMSN{2} ...
%     datMatrixMashPVMSN{1} datMatrixMashPVMSN{2} datMatrixMashPVMSN{4} ...
%     datStrioMashSpines{1} ...
%     datMatrixMashSpines{1} datMatrixMashSpines{2}};
% dlx  = {...
%     datStrioDlxPVMSN{2} ...
%     datMatrixDlxPVMSN{1}  datMatrixDlxPVMSN{2}  datMatrixDlxPVMSN{4} ...
%     datStrioMashSpines{1} ...
%     datMatrixDlxSpines{1} datMatrixDlxSpines{2}};

x = cellfun(@(d) mean(d), mash);
y = cellfun(@(d) mean(d), dlx);
xerr = cellfun(@(d) std_error(d), mash);
yerr = cellfun(@(d) std_error(d), dlx);

xPVMSN = x(1:4);
yPVMSN = y(1:4);
xerrPVMSN = xerr(1:4);
yerrPVMSN = yerr(1:4);

XPVMSN = [zeros(length(xPVMSN),1) xPVMSN'];
b1 = XPVMSN\yPVMSN';
yCalc1 = XPVMSN*b1;
Rsq1 = 1 - sum((yPVMSN' - yCalc1).^2)/sum((yPVMSN' - mean(yPVMSN)).^2);
[r1,p1] = corrcoef(xPVMSN, yPVMSN);
r1 = r1(2); p1 = p1(2);

f1 = figure;
hold on;
errorbar(xPVMSN, yPVMSN, yerrPVMSN, 'LineStyle', 'none', 'Color', 'k')
errorbar(xPVMSN, yPVMSN, xerrPVMSN, 'horizontal', 'LineStyle', 'none', 'Color', 'k');
for k=1:length(xPVMSN)
    scatter(xPVMSN(k), yPVMSN(k), 'filled');
end
plot([0 xPVMSN], [0; yCalc1], 'Color', 'b');
ylabel('DLX');
xlabel('Mash');
legend({'Error DLX', 'Error Mash', 'Strio PVMSN (Learned >= 16)', ...
    'Matrix PVMSN (Age <= 8)', 'Matrix PVMSN (Learned >= 16)', ...
    'Matrix PVMSN (HD Not Learned)'}, ...
    'Location', 'northwest')
title(sprintf(['Mash v Dlx comparison of PVMSN counts \n' ...
    'R^2=%.3f, b=(%.3f,%.3f), r=%.3f, p=%.3f'], Rsq1, b1(1), b1(2), r1, p1)); 

xSpines = x(5:end);
ySpines = y(5:end);
xerrSpines = xerr(5:end);
yerrSpines = yerr(5:end);

XSpines = [zeros(length(xSpines),1) xSpines'];
b2 = XSpines\ySpines';
yCalc2 = XSpines*b2;
Rsq2 = 1 - sum((ySpines' - yCalc2).^2)/sum((ySpines' - mean(ySpines)).^2);
[r2,p2] = corrcoef(xSpines, ySpines);
r2 = r2(2); p2 = p2(2);

f2 = figure;
hold on;
errorbar(xSpines, ySpines, yerrSpines, 'LineStyle', 'none', 'Color', 'k')
errorbar(xSpines, ySpines, xerrSpines, 'horizontal', 'LineStyle', 'none', 'Color', 'k');
for k=1:length(xSpines)
    scatter(xSpines(k), ySpines(k), 'filled');
end
plot([0 xSpines], [0; yCalc2], 'Color', 'b');
ylabel('DLX');
xlabel('Mash');
legend({'Error DLX', 'Error Mash', 'Strio Spines WT', ...
    'Matrix Spines WT', 'Matrix Spines HD'}, ...
    'Location', 'northwest')
title(sprintf(['Mash v Dlx comparison of Spines counts \n' ...
    'R^2=%.3f, b=(%.3f,%.3f), r=%.3f, p=%.3f'], Rsq2, b2(1), b2(2), r2, p2)); 

function [data, nAnimals] = getgroupdata_pvmsn(analysisdb, group)
data = [];
nAnimals = 0;
for i=1:length(group)
    mouse = group{i};
    blobs = getblobs(analysisdb, mouse.ID);
    if isempty(blobs)
        continue;
    end
        
    data = [data blobs(~isnan(blobs))];
    nAnimals = nAnimals + 1;
end
end

function [data, nAnimals] = getgroupdata_spines(analysisdb, group, obs)
data = [];
nAnimals = 0;

for i=1:length(group)
    mouse = group{i};
    spines = getspines(analysisdb, mouse.ID, obs);
    data = [data spines];
    if ~isempty(spines); nAnimals = nAnimals + 1; end
end
end