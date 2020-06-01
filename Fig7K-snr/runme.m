input = [1/18 17/18; 2/4 2/4];
X = [1 2];
N = [18 4];
b = bar(input, 'stacked');
[h,p, chi2stat,df] = prop_test(X , N, false);
suptitle(sprintf('chi2=%.4f', p));
set(gca, 'xTickLabel', {'Striosomal', 'Matrix'});
legend('Gain', 'SNR');
