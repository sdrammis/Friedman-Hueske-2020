% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTSNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\tiWTSNLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceTotalIntStrio.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdTotalIntensityArrS.mat')

%read in first stain data
valsWTSNLO = {};
names = tiWTSNLO.Properties.VariableNames;
for col = 1:size(tiWTSNLO,2)
    if contains(names{col}, '2018')
        valsWTSNLO = [valsWTSNLO tiWTSNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTSNLONorm = cell2mat(valsWTSNLO)';
valsWTSNLONormArr = (valsWTSNLONorm - allMiceAreaIntStrio) / stdAreaArrS;
reshapedArr = reshape(valsWTSNLONormArr, [1000 3]);
valsWTSNLONorm = num2cell(reshapedArr, [1 3]);


valsHDs = {};
names = tiHDs.Properties.VariableNames;
for col = 1:size(tiHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs tiHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDsNorm = cell2mat(valsHDm)';
valsHDsNormArr = (valsHDsNorm - allMiceAreaIntStrio) / stdAreaArrS;
reshapedArr = reshape(valsHDsNormArr, [1000 16]);
valsHDsNorm = num2cell(reshapedArr, [1 16]);


% valsWTSNLONorm = {};
% names = tiWTSLONorm.Properties.VariableNames;
% for col = 1:size(tiWTSNLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTSNLONorm = [valsWTSNLONorm tiWTSNLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDsNorm = {};
% names = tiHDsNorm.Properties.VariableNames;
% for col = 1:size(tiHDsNorm,2)
%     if contains(names{col}, '2018')
%         valsHDsNorm = [valsHDsNorm tiHDsNorm{:,col}'];
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
title(['Total Intensity HD strio vs. WT old learned strio. KS val = ', num2str(p)]);
% xlim([-3 9])
% ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSNLONorm, [0 1 0], []);
title(['Normalized Total Intensity HD strio vs. WT old learned strio. KS val = ', num2str(pNorm)]);
% xlim([-3 9])
% ylim([0 1])





