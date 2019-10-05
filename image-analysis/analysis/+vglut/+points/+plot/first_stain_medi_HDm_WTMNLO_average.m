COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediWTMNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\mediWTMNLONorm.mat')

%read in first stain data
valsWTMNLO = {};
names = mediWTMNLO.Properties.VariableNames;
for col = 1:size(mediWTMNLO,2)
    if contains(names{col}, '2018')
        valsWTMNLO = [valsWTMNLO mediWTMNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDm = {};
names = mediHDm.Properties.VariableNames;
for col = 1:size(mediHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm mediHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsWTMNLONorm = {};
names = mediWTMNLONorm.Properties.VariableNames;
for col = 1:size(mediWTMNLONorm,2)
    if contains(names{col}, '2018')
        valsWTMNLONorm = [valsWTMNLONorm mediWTMNLONorm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end

valsHDmNorm = {};
names = mediHDmNorm.Properties.VariableNames;
for col = 1:size(mediHDmNorm,2)
    if contains(names{col}, '2018')
        valsHDmNorm = [valsHDmNorm mediHDmNorm{:,col}'];
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
title(['Median Intensity HD matrix vs. WT old not learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLONorm, [0 1 0], []);
title(['Normalized Median Intensity HD matrix vs. WT old not learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


