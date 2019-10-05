COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTMLY.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTMLYNorm.mat')

%read in first stain data
valsWTMLY = {};
names = maxiWTMLY.Properties.VariableNames;
for col = 1:size(maxiWTMLY,2)
    if contains(names{col}, '2019')
        valsWTMLY = [valsWTMLY maxiWTMLY{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDm = {};
names = maxiHDm.Properties.VariableNames;
for col = 1:size(maxiHDm,2)
    if contains(names{col}, '2019')
        valsHDm = [valsHDm maxiHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTMLYNorm = {};
names = maxiWTMLYNorm.Properties.VariableNames;
for col = 1:size(maxiWTMLYNorm,2)
    if contains(names{col}, '2019')
        valsWTMLYNorm = [valsWTMLYNorm maxiWTMLYNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmNorm = {};
names = maxiHDmNorm.Properties.VariableNames;
for col = 1:size(maxiHDmNorm,2)
    if contains(names{col}, '2019')
        valsHDmNorm = [valsHDmNorm maxiHDmNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmArr = cell2mat(valsHDm)';
valsWTMLYArr = cell2mat(valsWTMLY)';
valsHDmNormArr = cell2mat(valsHDmNorm)';
valsWTMLYNormArr = cell2mat(valsWTMLYNorm)';

[h,p] = kstest2(valsHDmArr, valsWTMLYArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMLYNormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLY, [0 1 0], []);
title(['Max Intensity HD matrix vs. WT young learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLYNorm, [0 1 0], []);
title(['Normalized Max Intensity HD matrix vs. WT young learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


