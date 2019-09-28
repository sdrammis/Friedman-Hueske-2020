strioMiceLWT = filter_good_mice(get_mice(miceType, 'health', 'WT', 'striosomality', "Strio", 'learned'));
strioMiceNLWT = filter_good_mice(get_mice(miceType, 'health', 'WT', 'striosomality', "Strio", 'not-learned'));
strioMiceNLHD = filter_good_mice(get_mice(miceType, 'health', 'HD', 'striosomality', "Strio", 'not-learned'));

matrixMiceLWT = filter_good_mice(get_mice(miceType, 'health', 'WT', 'striosomality', "Matrix", 'learned'));
matrixMiceNLWT = filter_good_mice(get_mice(miceType, 'health', 'WT', 'striosomality', "Matrix", 'not-learned'));
matrixMiceNLHD = filter_good_mice(get_mice(miceType, 'health', 'HD', 'striosomality', "Matrix", 'not-learned'));

[strioStatsLWT, strioExidsLWT] = get_mice_stats(T, strioMiceLWT);
[strioStatsNLWT, strioExidsNLWT] = get_mice_stats(T, strioMiceNLWT);
[strioStatsNLHD, strioExidsNLHD] = get_mice_stats(T, strioMiceNLHD);

[matrixStatsLWT, matrixExidsLWT] = get_mice_stats(T, matrixMiceLWT);
[matrixStatsNLWT, matrixExidsNLWT] = get_mice_stats(T, matrixMiceNLWT);
[matrixStatsNLHD, matrixExidsNLHD] = get_mice_stats(T, matrixMiceNLHD);

[~, pLWT] = ttest2(strioStatsLWT, matrixStatsLWT);
[~, pNLWT] = ttest2(strioStatsNLWT, matrixStatsNLWT);
[~, pNLHD] = ttest2(strioStatsNLHD, matrixStatsNLHD);
[~, pWT] = ttest2([strioStatsLWT strioStatsNLWT], [matrixStatsLWT matrixStatsNLWT]);

figure;
subplot(1,2,1);
plot_mice_bars(strioStatsLWT, strioStatsNLWT, strioStatsNLHD, 'Strio')
ylim([0 16*10^2])
subplot(1,2,2);
plot_mice_bars(matrixStatsLWT, matrixStatsNLWT, matrixStatsNLHD, 'Matrix')
ylim([0 16*10^2])
sgtitle([sprintf('Strio vs Matrix LWT p-val=%.3f', pLWT) newline ...
    sprintf('Strio vs Matrix NLWT p-val=%.3f', pNLWT) newline ...
    sprintf('Strio vs Matrix NLHD p-val=%.3f', pNLHD) newline ...
    sprintf('Strio vs Matrix WT p-val=%.3f', pWT)]);

outT = cell2table({ -1, -1, -1});
outT.Properties.VariableNames = {'mouseID', 'val', 'group'};
outT = add_to_out(outT, strioStatsLWT, strioExidsLWT, 'StrioLWT');
outT = add_to_out(outT, strioStatsNLWT, strioExidsNLWT, 'StrioNLWT');
outT = add_to_out(outT, strioStatsNLHD, strioExidsNLHD, 'StrioNLHD');
outT = add_to_out(outT, matrixStatsLWT, matrixExidsLWT, 'MatrixLWT');
outT = add_to_out(outT, matrixStatsNLWT, matrixExidsNLWT, 'MatrixNLWT');
outT = add_to_out(outT, matrixStatsNLHD, matrixExidsNLHD, 'MatrixNLHD');
writetable(outT, 'results_table.csv')

function outT = add_to_out(outT, stats, exids, group)
for i=1:length(stats)
    exidsSplit = split(exids{i}, '_');
    mouseID = exidsSplit(2);
    outT = [outT; { mouseID, stats(i), group }];
    
end
end


function plot_mice_bars(statsLWT, statsNLWT, statsNLHD, title_)
statsWT = [statsLWT statsNLWT];
plot_bars({ statsLWT, statsNLWT, statsWT, statsNLHD }, ...
    {'Learned WT', 'Not Learned WT', 'All WT', 'Not Learned HD'});
[~, p1] = ttest2(statsLWT, statsNLWT);
[~, p2] = ttest2(statsLWT, statsNLHD);
[~, p3] = ttest2(statsNLWT, statsNLHD);
[~, p4] = ttest2(statsWT, statsNLHD);
title([title_ newline ...
    sprintf('LWT vs NLWT p-val=%.3f', p1) newline ...
    sprintf('LWT vs NLHD p-val=%.3f', p2) newline ...
    sprintf('NLWT vs NLHD p-val=%.3f', p3) newline ...
    sprintf('WT vs NLHD p-val=%.3f', p4)]);
ylabel('(# of spines) / (dendrite length in pixel)')
end

function [stats, exids] = get_mice_stats(T, mice)
stats = [];
exids = [];
for i=1:length(mice)
    mouse = mice(i);
    [mouseStats, mouseExids] = get_mouse_stat(T, mouse);
    if mouseStats == -1
        continue;
    end
    
    exids = [exids mouseExids'];
    stats = [stats mouseStats'];
end
end

function [stats, exids] = get_mouse_stat(T, mouse)
idxs = ~cellfun('isempty', strfind(T.exid, ['_' mouse.ID '_']));
if sum(idxs) == 0
    stats = -1;
    exids = -1;
    return
end

exids = T.exid(idxs);
dendLen = T.dendLength(idxs);
numSpines = T.numSpines(idxs);
stats = numSpines ./ dendLen;
stats = stats(~isnan(stats));
end

function retMice = filter_good_mice(mice)
histology = abs([mice(:).histologyStriosomality]);
goodIdxs = histology == 1.5 | histology == 2;
unknownIdxs = histology == 10;
retMice = mice(goodIdxs | unknownIdxs);
end