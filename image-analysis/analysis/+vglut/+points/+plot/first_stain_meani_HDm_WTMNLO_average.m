COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTMNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\meaniWTMNLONorm.mat')

%read in first stain data
valsWTMNLO = {};
names = meaniWTMNLO.Properties.VariableNames;
for col = 1:size(meaniWTMNLO,2)
    if contains(names{col}, '2018')
        valsWTMNLO = [valsWTMNLO meaniWTMNLO{:,col}'];
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

valsWTMNLONorm = {};
names = meaniWTMNLONorm.Properties.VariableNames;
for col = 1:size(meaniWTMNLONorm,2)
    if contains(names{col}, '2018')
        valsWTMNLONorm = [valsWTMNLONorm meaniWTMNLONorm{:,col}'];
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
valsWTMNLOArr = cell2mat(valsWTMNLO)';
valsHDmNormArr = cell2mat(valsHDmNorm)';
valsWTMNLONormArr = cell2mat(valsWTMNLONorm)';

[h,p] = kstest2(valsHDmArr, valsWTMNLOArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMNLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLO, [0 1 0], []);
title(['Mean Intensity HD matrix vs. WT old not learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLONorm, [0 1 0], []);
title(['Normalized Mean Intensity HD matrix vs. WT old not learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


