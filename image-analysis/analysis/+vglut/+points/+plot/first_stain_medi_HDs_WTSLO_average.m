COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediWTSLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediWTSLONorm.mat')

%read in first stain data
valsWTSLO = {};
names = mediWTSLO.Properties.VariableNames;
for col = 1:size(mediWTSLO,2)
    if contains(names{col}, '2018')
        valsWTSLO = [valsWTSLO mediWTSLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDs = {};
names = mediHDs.Properties.VariableNames;
for col = 1:size(mediHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs mediHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTSLONorm = {};
names = mediWTSLONorm.Properties.VariableNames;
for col = 1:size(mediWTSLONorm,2)
    if contains(names{col}, '2018')
        valsWTSLONorm = [valsWTSLONorm mediWTSLONorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDsNorm = {};
names = mediHDsNorm.Properties.VariableNames;
for col = 1:size(mediHDsNorm,2)
    if contains(names{col}, '2018')
        valsHDsNorm = [valsHDsNorm mediHDsNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDsArr = cell2mat(valsHDs)';
valsWTSLOArr = cell2mat(valsWTSLO)';
valsHDsNormArr = cell2mat(valsHDsNorm)';
valsWTSLONormArr = cell2mat(valsWTSLONorm)';

[h,p] = kstest2(valsHDsArr, valsWTSLOArr);
[hNorm,pNorm] = kstest2(valsHDsNormArr, valsWTSLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDs, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLO, [0 1 0], []);
title(['Median Intensity HD strio vs. WT old learned strio. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLONorm, [0 1 0], []);
title(['Normalized Median Intensity HD strio vs. WT old learned strio. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])





