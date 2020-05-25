strioT = load('selected_strio_pairs.mat');
matrixT = load('selected_matrix_pairs.mat');

striomaxs = cellfun(@max, strioT.T.dat_y);
striomins = cellfun(@min, strioT.T.dat_y);
matrixmaxs = cellfun(@max, matrixT.T.dat_y);
matrixmins = cellfun(@min, matrixT.T.dat_y);

striorange = striomaxs - striomins;
matrixrange = matrixmaxs - matrixmins;

[h,p] = kstest2(striorange,matrixrange);

f = figure;
hold on;
cdfplot(striorange);
cdfplot(matrixrange);
legend('Strio', 'Matrix');
title(sprintf('Activity range (strio v matrix) - p=%.5f', p));
xlabel('SPN activity range (max(activity) - min(activity)');
ylabel('% of neuron pairs');
