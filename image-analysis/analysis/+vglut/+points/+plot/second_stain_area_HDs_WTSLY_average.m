COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTSLY.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTSLYNorm.mat')

%read in first stain data
valsWTSLY = {};
names = areaWTSLY.Properties.VariableNames;
for col = 1:size(areaWTSLY,2)
    if contains(names{col}, '2019')
        valsWTSLY = [valsWTSLY areaWTSLY{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDs = {};
names = areaHDs.Properties.VariableNames;
for col = 1:size(areaHDs,2)
    if contains(names{col}, '2019')
        valsHDs = [valsHDs areaHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTSLYNorm = {};
names = areaWTSLYNorm.Properties.VariableNames;
for col = 1:size(areaWTSLYNorm,2)
    if contains(names{col}, '2019')
        valsWTSLYNorm = [valsWTSLYNorm areaWTSLYNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDsNorm = {};
names = areaHDsNorm.Properties.VariableNames;
for col = 1:size(areaHDsNorm,2)
    if contains(names{col}, '2019')
        valsHDsNorm = [valsHDsNorm areaHDsNorm{:,col}'];
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
title(['Area HD strio vs. WT young learned strio. KS val = ', num2str(p)]);
xlim([-3 9])
ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLYNorm, [0 1 0], []);
title(['Normalized Area HD strio vs. WT young learned strio. KS val = ', num2str(pNorm)]);
xlim([-3 9])
ylim([0 1])





