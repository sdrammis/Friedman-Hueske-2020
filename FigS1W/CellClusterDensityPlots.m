%% plots data for final strio and matrix data
fig1 = figure(1);
bar([1 2], [mean(finalStrioAnalysis.ratio) mean(finalMatrixAnalysis.ratio)], 0.5)
hold on
text(0.75, 0.7, 'p = 0.0083')
text(1.75, -0.68, 'p = 0.0294')
ylim([-0.8 0.8])
xlim([0 3.25])
ylabel({'# cells/mm^{2}','(S-M)/(S+M)'});
xticks([])
yticks([-0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8])
yticklabels({'-0.8','','','','','','','','0.8'})
set(gca,'box','off','XAxisLocation','origin','LineWidth',1.05,'TickLength',[0.005 0.01],'FontSize',18)
er = errorbar([1 2],[mean(finalStrioAnalysis.ratio) mean(finalMatrixAnalysis.ratio)],...
    [std(finalStrioAnalysis.ratio) std(finalMatrixAnalysis.ratio)]/sqrt(5),...
    [std(finalStrioAnalysis.ratio) std(finalMatrixAnalysis.ratio)]/sqrt(5),...
    'CapSize', 0);
er.Color = [0 0 0];
er.LineStyle = 'none';
scatter([0.8*ones(1,5) 1.8*ones(1,5)],[finalStrioAnalysis.ratio finalMatrixAnalysis.ratio],'*','k')
hold off

%% plots for cell counts
clusterRatioSA = (finalStrioAnalysis.fullStrioClusterCount-finalStrioAnalysis.fullMatrixClusterCount)./(finalStrioAnalysis.fullStrioClusterCount+finalStrioAnalysis.fullMatrixClusterCount);
clusterRatioMA = (finalMatrixAnalysis.fullStrioClusterCount-finalMatrixAnalysis.fullMatrixClusterCount)./(finalMatrixAnalysis.fullStrioClusterCount+finalMatrixAnalysis.fullMatrixClusterCount);
fig2 = figure(2);
bar([1 2], [mean(clusterRatioSA) mean(clusterRatioMA)], 0.5)
hold on
text(0.75, 0.75, 'p = 0.0198')
text(1.75, -1.07, 'p = 0.0022')
ylim([-1.2 1.2])
ylabel({'# clusters with 30% max strio density','(S-M)/(S+M)'})
xticks([])
yticks([-1.2 -1 -0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8, 1, 1.2])
yticklabels({'-1.2','','','','','','','','','','','','1.2'})
set(gca,'box','off','XAxisLocation','origin','LineWidth',1.05,'TickLength',[0.005 0.01],'FontSize',18)
er = errorbar([1 2],[mean(clusterRatioSA) mean(clusterRatioMA)],...
    [std(clusterRatioSA) std(clusterRatioMA)]/sqrt(5),...
    [std(clusterRatioSA) std(clusterRatioMA)]/sqrt(5), 'CapSize', 0);
er.Color = [0 0 0];
er.LineStyle = 'none';
scatter([0.8*ones(1,5) 1.8*ones(1,5)], [clusterRatioSA clusterRatioMA],'*','k')
hold off

%% Best Examples
% first load the figures Sabrina is giving
hold on
% this plots the max strio circle at center [x y] with radius r
viscircles([2379 15663], 319, 'Color', 'green');
% this plots the max matrix circle
viscircles([1313 19303], 319, 'Color', 'cyan');
% this plots the cells within that circle (MAKE SURE TO LOAD CORRECT CELL
% CENTERS AND SELECT CORRECT STRIO NUMBER
%plot(cellCenters.strio5Centers(:,1), cellCenters.strio5Centers(:,2), '+', 'Color', 'green', 'MarkerSize', 14, 'LineWidth', 2);
strio = [];
categories = fieldnames(cellCenters);
for i = 1:numel(categories)
    category = categories{i};
    if contains(category,'strio') && contains(category,'Centers')
        strio = [strio; cellCenters.(category)];
    end
end
plot(strio(:,1), strio(:,2),'+', 'Color', 'green', 'MarkerSize', 14, 'LineWidth', 2);
% plots matrix cells within the circle
matrix = cellCenters.matrixCenters;
% idx = rangesearch(matrix, [1313 19303], 319);
% plot(matrix(idx{1},1), matrix(idx{1},2), '+', 'Color', 'cyan', 'MarkerSize', 14, 'LineWidth', 2);
plot(matrix(:,1), matrix(:,2), '+', 'Color', 'cyan', 'MarkerSize', 14, 'LineWidth', 2);
hold off
