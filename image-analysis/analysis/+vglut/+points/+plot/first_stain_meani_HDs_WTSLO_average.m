%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTSLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTSLONorm.mat')



%read in first stain data
valsWTSLO = {};
names = meaniWTSLO.Properties.VariableNames;
for col = 1:size(meaniWTSLO,2)
    if contains(names{col}, '2018')
        valsWTSLO = [valsWTSLO meaniWTSLO{:,col}'];
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

valsWTSLONorm = {};
names = meaniWTSLONorm.Properties.VariableNames;
for col = 1:size(meaniWTSLONorm,2)
    if contains(names{col}, '2018')
        valsWTSLONorm = [valsWTSLONorm meaniWTSLONorm{:,col}'];
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
title(['Mean Intensity HD strio vs. WT old learned strio. KS val = ', num2str(p)]);
xlim([-3 9])
ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLONorm, [0 1 0], []);
title(['Normalized Mean Intensity HD strio vs. WT old learned strio. KS val = ', num2str(pNorm)]);
xlim([-3 9])
ylim([0 1])





