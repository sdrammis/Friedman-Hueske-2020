COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTSNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTSNLONorm.mat')

%read in first stain data
valsWTSNLO = {};
names = meaniWTSNLO.Properties.VariableNames;
for col = 1:size(meaniWTSNLO,2)
    if contains(names{col}, '2018')
        valsWTSNLO = [valsWTSNLO meaniWTSNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDs = {};
names = meaniHDs.Properties.VariableNames;
for col = 1:size(meaniHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs meaniHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTSNLONorm = {};
names = meaniWTSNLONorm.Properties.VariableNames;
for col = 1:size(meaniWTSNLONorm,2)
    if contains(names{col}, '2018')
        valsWTSNLONorm = [valsWTSNLONorm meaniWTSNLONorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDsNorm = {};
names = meaniHDsNorm.Properties.VariableNames;
for col = 1:size(meaniHDsNorm,2)
    if contains(names{col}, '2018')
        valsHDsNorm = [valsHDsNorm meaniHDsNorm{:,col}'];
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
title(['Mean Intensity HD strio vs. WT old not learned strio. KS val = ', num2str(p)]);
xlim([-3 9])
ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSNLONorm, [0 1 0], []);
title(['Normalized Mean Intensity HD strio vs. WT old not learned strio. KS val = ', num2str(pNorm)]);
xlim([-3 9])
ylim([0 1])





