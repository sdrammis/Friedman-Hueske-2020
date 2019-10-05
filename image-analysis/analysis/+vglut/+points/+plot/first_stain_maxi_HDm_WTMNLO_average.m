% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTMNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDMNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTMNLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceMaxIntMat.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdMaxIntensityArrM.mat')

%read in first stain data
valsWTMNLO = {};
names = maxiWTMNLO.Properties.VariableNames;
for col = 1:size(maxiWTMNLO,2)
    if contains(names{col}, '2018')
        valsWTMNLO = [valsWTMNLO maxiWTMNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMNLONorm = cell2mat(valsWTMNLO)';
valsWTMNLONormArr = (valsWTMNLONorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsWTMNLONormArr, [1000 3]);
valsWTMNLONorm = num2cell(reshapedArr, [1 3]);


valsHDm = {};
names = maxiHDm.Properties.VariableNames;
for col = 1:size(maxiHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm maxiHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDmNorm = cell2mat(valsHDm)';
valsHDmNormArr = (valsHDmNorm - allMiceAreaIntMat) / stdAreaArrM;
reshapedArr = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArr, [1 16]);


% valsWTMNLONorm = {};
% names = maxiWTMNLONorm.Properties.VariableNames;
% for col = 1:size(maxiWTMNLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMNLONorm = [valsWTMNLONorm maxiWTMNLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDmNorm = {};
% names = maxiHDmNorm.Properties.VariableNames;
% for col = 1:size(maxiHDmNorm,2)
%     if contains(names{col}, '2018')
%         valsHDmNorm = [valsHDmNorm maxiHDmNorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end


valsHDmArr = cell2mat(valsHDm)';
valsWTMNLOArr = cell2mat(valsWTMNLO)';
% valsHDmNormArr = cell2mat(valsHDmNorm)';
% valsWTMNLONormArr = cell2mat(valsWTMNLONorm)';

[h,p] = kstest2(valsHDmArr, valsWTMNLOArr);
[hNorm,pNorm] = kstest2(valsHDmNormArr, valsWTMNLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLO, [0 1 0], []);
title(['Max Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMNLONorm, [0 1 0], []);
title(['Normalized Max Intensity HD matrix vs. WT old learned matrix. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])


