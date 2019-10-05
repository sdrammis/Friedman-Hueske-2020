COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTMLY.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTMLYNorm.mat')

%read in first stain data
valsWTMLY = {};
names = tiWTMLY.Properties.VariableNames;
for col = 1:size(tiWTMLY,2)
    if contains(names{col}, '2019')
        valsWTMLY = [valsWTMLY tiWTMLY{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDm = {};
names = tiHDm.Properties.VariableNames;
for col = 1:size(tiHDm,2)
    if contains(names{col}, '2019')
        valsHDm = [valsHDm tiHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTMLYNorm = {};
names = tiWTMLYNorm.Properties.VariableNames;
for col = 1:size(tiWTMLYNorm,2)
    if contains(names{col}, '2019')
        valsWTMLYNorm = [valsWTMLYNorm tiWTMLYNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmNorm = {};
names = tiHDmNorm.Properties.VariableNames;
for col = 1:size(tiHDmNorm,2)
    if contains(names{col}, '2019')
        valsHDmNorm = [valsHDmNorm tiHDmNorm{:,col}'];
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
title(['Total Intensity HD matrix vs. WT young learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLYNorm, [0 1 0], []);
title(['Normalized Total Intensity HD matrix vs. WT young learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


