% These paramaters should be updated by hand by consulting the data and 
% a chi-squared tabled.
N_STRIO = 35;
A_STRIO = 51.966;
B_STRIO = 19.806;
N_MATRIX = 77;
A_MATRIX = 101.999;
B_MATRIX = 53.782;

striodur = load('./strio_duration.mat');
matrixdur = load('./matrix_duration.mat');
striodur = striodur.duration;
matrixdur = matrixdur.duration;

s2_strio = var(striodur); % By default this normalizes by (n - 1)
s2_matrix = var(matrixdur);

uCI_strio = ((N_STRIO - 1) * s2_strio) / B_STRIO;
lCI_strio = ((N_STRIO - 1) * s2_strio) / A_STRIO;
uCI_matrix = ((N_MATRIX - 1) * s2_matrix) / B_MATRIX;
lCI_matrix = ((N_MATRIX - 1) * s2_matrix) / A_MATRIX;

[h,p] = vartest2(striodur, matrixdur);

f = figure;
hold on;
bar(1, s2_strio);
bar(2, s2_matrix);
errorbar(1, s2_strio, lCI_strio, uCI_strio, 'k');
errorbar(2, s2_matrix, lCI_matrix, uCI_matrix, 'k');
set(gca, 'xtick', [1 2], 'xticklabel', {'Strio', 'Matrix'});
ylabel('Firing rate change duration');
title(sprintf('Change durations (strio vs matrix), p=%.5f', p));
