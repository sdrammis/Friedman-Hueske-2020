% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTSNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\maxiWTSNLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceMaxIntStrio.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdMaxIntensityArrS.mat')

%read in first stain data
valsWTSNLO = {};
names = maxiWTSNLO.Properties.VariableNames;
for col = 1:size(maxiWTSNLO,2)
    if contains(names{col}, '2018')
        valsWTSNLO = [valsWTSNLO maxiWTSNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTSLONorm = cell2mat(valsWTSNLO)';
valsWTSLONormArr = (valsWTSLONorm - allMiceAreaIntStrio) / stdAreaArrS;
reshapedArr = reshape(valsWTSLONormArr, [1000 3]);
valsWTSLONorm = num2cell(reshapedArr, [1 3]);


valsHDs = {};
names = maxiHDs.Properties.VariableNames;
for col = 1:size(maxiHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs maxiHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDsNorm = cell2mat(valsHDm)';
valsHDsNormArr = (valsHDsNorm - allMiceAreaIntStrio) / stdAreaArrS;
reshapedArr = reshape(valsHDsNormArr, [1000 16]);
valsHDsNorm = num2cell(reshapedArr, [1 16]);


% valsWTSNLONorm = {};
% names = maxiWTSNLONorm.Properties.VariableNames;
% for col = 1:size(maxiWTSNLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTSNLONorm = [valsWTSNLONorm maxiWTSNLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDsNorm = {};
% names = maxiHDsNorm.Properties.VariableNames;
% for col = 1:size(maxiHDsNorm,2)
%     if contains(names{col}, '2018')
%         valsHDsNorm = [valsHDsNorm maxiHDsNorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end

valsHDsArr = cell2mat(valsHDs)';
valsWTSNLOArr = cell2mat(valsWTSNLO)';
% valsHDsNormArr = cell2mat(valsHDsNorm)';
% valsWTSNLONormArr = cell2mat(valsWTSNLONorm)';

[h,p] = kstest2(valsHDsArr, valsWTSNLOArr);
[hNorm,pNorm] = kstest2(valsHDsNormArr, valsWTSNLONormArr);

%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDs, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSNLO, [0 1 0], []);
title(['Max Intensity HD strio vs. WT old not learned strio. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSNLONorm, [0 1 0], []);
title(['Normalized Max Intensity HD strio vs. WT old not learned strio. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])





