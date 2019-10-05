COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTSLY.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTSLYNorm.mat')

%read in first stain data
valsWTSLY = {};
names = tiWTSLY.Properties.VariableNames;
for col = 1:size(tiWTSLY,2)
    if contains(names{col}, '2019')
        valsWTSLY = [valsWTSLY tiWTSLY{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDs = {};
names = tiHDs.Properties.VariableNames;
for col = 1:size(tiHDs,2)
    if contains(names{col}, '2019')
        valsHDs = [valsHDs tiHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTSLYNorm = {};
names = tiWTSLYNorm.Properties.VariableNames;
for col = 1:size(tiWTSLYNorm,2)
    if contains(names{col}, '2019')
        valsWTSLYNorm = [valsWTSLYNorm tiWTSLYNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDsNorm = {};
names = tiHDsNorm.Properties.VariableNames;
for col = 1:size(tiHDsNorm,2)
    if contains(names{col}, '2019')
        valsHDsNorm = [valsHDsNorm tiHDsNorm{:,col}'];
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
title(['Total Intensity HD strio vs. WT young learned strio. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLYNorm, [0 1 0], []);
title(['Normalized Total Intensity HD strio vs. WT young learned strio. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])





