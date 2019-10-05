% COLORS = cbrewer('qual', 'Set2', 50);

% load('./path/to/areaHDm.mat');\

%load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTSNLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaHDsNorm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\areaWTSNLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\allMiceAreaIntStrio.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp\stdAreaArrS.mat')

%read in first stain data
valsWTSNLO = {};
names = areaWTSNLO.Properties.VariableNames;
for col = 1:size(areaWTSNLO,2)
    if contains(names{col}, '2018')
        valsWTSNLO = [valsWTSNLO areaWTSNLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTSLONorm = cell2mat(valsWTSLO)';
valsWTSLONormArr = (valsWTSLONorm - allMiceAreaIntStrio) / stdAreaArrS;
reshapedArr = reshape(valsWTSLONormArr, [1000 12]);
valsWTSLONorm = num2cell(reshapedArr, [1 12]);


valsHDs = {};
names = areaHDs.Properties.VariableNames;
for col = 1:size(areaHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs areaHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDsNorm = cell2mat(valsHDm)';
valsHDsNormArr = (valsHDsNorm - allMiceAreaIntStrio) / stdAreaArrS;
reshapedArr = reshape(valsHDsNormArr, [1000 16]);
valsHDsNorm = num2cell(reshapedArr, [1 16]);


% valsWTSNLONorm = {};
% names = areaWTSNLONorm.Properties.VariableNames;
% for col = 1:size(areaWTSNLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTSNLONorm = [valsWTSNLONorm areaWTSNLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDsNorm = {};
% names = areaHDsNorm.Properties.VariableNames;
% for col = 1:size(areaHDsNorm,2)
%     if contains(names{col}, '2018')
%         valsHDsNorm = [valsHDsNorm areaHDsNorm{:,col}'];
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
title(['Area HD strio vs. WT old not learned strio. KS val = ', num2str(p)]);
xlim([-3 9])
ylim([0 1])
subplot(1,2,2);
plot.avgcdf(gca, valsHDsNorm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSNLONorm, [0 1 0], []);
title(['Normalized Area HD strio vs. WT old not learned strio. KS val = ', num2str(pNorm)]);
xlim([-3 9])
ylim([0 1])





