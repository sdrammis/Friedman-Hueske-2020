COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTSLY.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTSLYNorm.mat')

%read in first stain data
valsWTSLY = {};
names = maxiWTSLY.Properties.VariableNames;
for col = 1:size(maxiWTSLY,2)
    if contains(names{col}, '2019')
        valsWTSLY = [valsWTSLY maxiWTSLY{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDs = {};
names = maxiHDs.Properties.VariableNames;
for col = 1:size(maxiHDs,2)
    if contains(names{col}, '2019')
        valsHDs = [valsHDs maxiHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTSLYNorm = {};
names = maxiWTSLYNorm.Properties.VariableNames;
for col = 1:size(maxiWTSLYNorm,2)
    if contains(names{col}, '2019')
        valsWTSLYNorm = [valsWTSLYNorm maxiWTSLYNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDsNorm = {};
names = maxiHDsNorm.Properties.VariableNames;
for col = 1:size(maxiHDsNorm,2)
    if contains(names{col}, '2019')
        valsHDsNorm = [valsHDsNorm maxiHDsNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDsArr = cell2mat(valsHDs)';
valsWTSLYArr = cell2mat(valsWTSLY)';
valsHDsNormArr = cell2mat(valsHDsNorm)';
valsWTSLYNormArr = cell2mat(valsWTSLYNorm)';

[h,p] = kstest2(valsHDsArr, valsWTSLYArr);
[hNorm,pNorm] = kstest2(valsHDsNormArr, valsWTSLYNormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDs, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLY, [0 1 0], []);
title(['Max Intensity HD strio vs. WT young learned strio. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLYNorm, [0 1 0], []);
title(['Normalized Max Intensity HD strio vs. WT young learned strio. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])





