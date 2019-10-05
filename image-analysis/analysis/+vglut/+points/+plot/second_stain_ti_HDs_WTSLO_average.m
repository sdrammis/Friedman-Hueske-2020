COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTSLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTSLONorm.mat')

%read in first stain data
valsWTSLO = {};
names = tiWTSLO.Properties.VariableNames;
for col = 1:size(tiWTSLO,2)
    if contains(names{col}, '2019')
        valsWTSLO = [valsWTSLO tiWTSLO{:,col}'];
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

valsWTSLONorm = {};
names = tiWTSLONorm.Properties.VariableNames;
for col = 1:size(tiWTSLONorm,2)
    if contains(names{col}, '2019')
        valsWTSLONorm = [valsWTSLONorm tiWTSLONorm{:,col}'];
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
title(['Total Intensity HD strio vs. WT old learned strio. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLONorm, [0 1 0], []);
title(['Normalized Total Intensity HD strio vs. WT old learned strio. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])





