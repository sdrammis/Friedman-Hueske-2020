COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTMLONorm.mat')

%read in first stain data
valsWTMLO = {};
names = meaniWTMLO.Properties.VariableNames;
for col = 1:size(meaniWTMLO,2)
    if contains(names{col}, '2018')
        valsWTMLO = [valsWTMLO meaniWTMLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDm = {};
names = meaniHDm.Properties.VariableNames;
for col = 1:size(meaniHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm meaniHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTMLONorm = {};
names = meaniWTMLONorm.Properties.VariableNames;
for col = 1:size(meaniWTMLONorm,2)
    if contains(names{col}, '2018')
        valsWTMLONorm = [valsWTMLONorm meaniWTMLONorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmNorm = {};
names = meaniHDmNorm.Properties.VariableNames;
for col = 1:size(meaniHDmNorm,2)
    if contains(names{col}, '2018')
        valsHDmNorm = [valsHDmNorm meaniHDmNorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmArr = cell2mat(valsHDm)';
valsWTMLOArr = cell2mat(valsWTMLO)';
valsHDmNormArr = cell2mat(valsHDmNorm)';
valsWTMLONormArr = cell2mat(valsWTMLONorm)';

[h,p] = kstest2(valsHDmArr, valsWTMLOArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLO, [0 1 0], []);
title(['Mean Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
title(['Normalized Mean Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


