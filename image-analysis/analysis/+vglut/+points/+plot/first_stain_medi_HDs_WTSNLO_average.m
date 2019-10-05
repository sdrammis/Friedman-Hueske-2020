COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediWTSNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediWTSNLONorm.mat')

%read in first stain data
valsWTSNLO = {};
names = mediWTSNLO.Properties.VariableNames;
for col = 1:size(mediWTSNLO,2)
    if contains(names{col}, '2018')
        valsWTSNLO = [valsWTSNLO mediWTSNLO{:,col}'];
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

valsWTSNLONorm = {};
names = mediWTSNLONorm.Properties.VariableNames;
for col = 1:size(mediWTSNLONorm,2)
    if contains(names{col}, '2018')
        valsWTSNLONorm = [valsWTSNLONorm mediWTSNLONorm{:,col}'];
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
valsWTSNLOArr = cell2mat(valsWTSNLO)';
valsHDsNormArr = cell2mat(valsHDsNorm)';
valsWTSNLONormArr = cell2mat(valsWTSNLONorm)';

[h,p] = kstest2(valsHDsArr, valsWTSNLOArr);
[hNorm,pNorm] = kstest2(valsHDsNormArr, valsWTSNLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDs, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSNLO, [0 1 0], []);
title(['Median Intensity HD strio vs. WT old not learned strio. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSNLONorm, [0 1 0], []);
title(['Normalized Median Intensity HD strio vs. WT old not learned strio. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])





