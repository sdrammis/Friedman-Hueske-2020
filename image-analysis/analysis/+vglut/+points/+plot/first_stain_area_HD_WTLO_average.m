%% load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaWTSLO.mat')

% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaHDmNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaWTMLONorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaHDsNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\areaWTSLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\allMiceAreaInt.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\stdAreaArr.mat')

%% Normalization factors
allMiceAreaInt = (allMiceAreaIntStrio + allMiceAreaIntMat) / 2;
stdAreaArr = (stdAreaArrS + stdAreaArrM) / 2;

%% read in first stain data and prefrom normalization for HDs, HDm, WTs and WTm 
valsWTMLO = {};
names = areaWTMLO.Properties.VariableNames;
for col = 1:size(areaWTMLO,2)
    if contains(names{col}, '2018')
        valsWTMLO = [valsWTMLO areaWTMLO{:,col}'];        
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMLONorm = cell2mat(valsWTMLO)';
valsWTMLONormArr = (valsWTMLONorm - allMiceAreaInt) / stdAreaArr;
reshapedArrWTMLO = reshape(valsWTMLONormArr, [1000 12]);
valsWTMLONorm = num2cell(reshapedArrWTMLO, [1 12]);

valsHDm = {};
names = areaHDm.Properties.VariableNames;
for col = 1:size(areaHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm areaHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDmNorm = cell2mat(valsHDm)';
valsHDmNormArr = (valsHDmNorm - allMiceAreaInt) / stdAreaArr;
reshapedArrHDm = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArrHDm, [1 16]);

%read in first stain data
valsWTSLO = {};
names = areaWTSLO.Properties.VariableNames;
for col = 1:size(areaWTSLO,2)
    if contains(names{col}, '2018')
        valsWTSLO = [valsWTSLO areaWTSLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTSLONorm = cell2mat(valsWTSLO)';
valsWTSLONormArr = (valsWTSLONorm - allMiceAreaInt) / stdAreaArr;
reshapedArrWTSLO = reshape(valsWTSLONormArr, [1000 12]);
valsWTSLONorm = num2cell(reshapedArrWTSLO, [1 12]);

valsHDs = {};
names = areaHDs.Properties.VariableNames;
for col = 1:size(areaHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs areaHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDsNorm = cell2mat(valsHDs)';
valsHDsNormArr = (valsHDsNorm - allMiceAreaInt) / stdAreaArr;
reshapedArrHDs = reshape(valsHDsNormArr, [1000 16]);
valsHDsNorm = num2cell(reshapedArrHDs, [1 16]);

%% Original method of Normalization. To use this, you must uncomment the load statments at the top as well.
% valsWTSLONorm = {};
% names = areaWTSLONorm.Properties.VariableNames;
% for col = 1:size(areaWTSLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTSLONorm = [valsWTSLONorm areaWTSLONorm{:,col}'];
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
% 
valsHDsArr = cell2mat(valsHDs)';
valsWTSLOArr = cell2mat(valsWTSLO)';
% valsHDsNormArr = cell2mat(valsHDsNorm)';
% valsWTSLONormArr = cell2mat(valsWTSLONorm)';
% 
% valsWTMLONorm = {};
% names = areaWTMLONorm.Properties.VariableNames;
% for col = 1:size(areaWTMLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMLONorm = [valsWTMLONorm areaWTMLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDmNorm = {};
% names = areaHDmNorm.Properties.VariableNames;
% for col = 1:size(areaHDmNorm,2)
%     if contains(names{col}, '2018')
%         valsHDmNorm = [valsHDmNorm areaHDmNorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
valsHDmArr = cell2mat(valsHDm)';
valsWTMLOArr = cell2mat(valsWTMLO)';
% valsHDmNormArr = cell2mat(valsHDmNorm)';
% valsWTMLONormArr = cell2mat(valsWTMLONorm)';
% 
% 
% reshapedArrWTMLO = reshape(valsWTMLONormArr, [1000 12]);
% reshapedArrHDm = reshape(valsHDmNormArr, [1000 16]);
% reshapedArrWTSLO = reshape(valsWTSLONormArr, [1000 12]);
% reshapedArrHDs = reshape(valsHDsNormArr, [1000 16]);
%% KS tests
[hHDSvsWTS,pHDSvsWTS] = kstest2(valsHDsArr, valsWTSLOArr);
[hNormHDSvsWTS,pNormHDSvsWTS] = kstest2(valsHDsNormArr, valsWTSLONormArr);

[hHDMvsWTM,pHDMvsWTM] = kstest2(valsHDmArr, valsWTMLOArr);
[hNormHDMvsWTM,pNormHDMvsWTM] = kstest2(valsHDmNormArr, valsWTMLONormArr);

[hWTSvsWTM,pWTSvsWTM] = kstest2(valsWTSLOArr, valsWTMLOArr);
[hNormWTSvsWTM,pNormWTSvsWTM] = kstest2(valsWTSLONormArr, valsWTMLONormArr);

[hHDSvsHDM,pHDSvsHDM] = kstest2(valsHDsArr, valsHDmArr);
[hNormHDSvsHDM,pNormHDSvsHDM] = kstest2(valsHDsNormArr, valsHDmNormArr);

%% Produces table format data, ie. 1000 resampled data X number of mice
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\EMPTY VGluT_Particles_ZscoreAcrossWithinSection_TableFormat')
% save('reshapedArrWTMLOArea.mat','reshapedArrWTMLO');
% save('reshapedArrHDmArea.mat','reshapedArrHDm');
% save('reshapedArrWTSLOArea.mat','reshapedArrWTMLO');
% save('reshapedArrHDsArea.mat','reshapedArrHDs');
%% Exports normalized resampled data in single cloumn format
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\VGluT_Particles_ZscoreAcrossWholePopBetterNorm_concatenatedFormat')
% save('valsHDsNormArrArea.mat','valsHDsNormArr');
% save('valsHDmNormArrArea.mat','valsHDmNormArr');
% save('valsWTSLONormArrArea.mat','valsWTSLONormArr');
% save('valsWTMLONormArrArea.mat','valsWTMLONormArr');
%% Exports not normalized resampled data in single cloumn format
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\EMPTY VGluT_Particles_ZscoreAcrossWithinSection_TableFormat\Raw')
% save('valsHDsArrArea.mat','valsHDsArr');
% save('valsHDmArrArea.mat','valsHDmArr');
% save('valsWTSLOArrArea.mat','valsWTSLOArr');
% save('valsWTMLOArrArea.mat','valsWTMLOArr');
%%
%plot average cdfs
figure;
subplot(1,2,1);
plot.avgcdf(gca, valsHDm, [1 0 0], []);
hold on;
plot.avgcdf(gca, valsWTMLO, [0 1 0], []);
hold on;
plot.avgcdf(gca, valsHDs, [0 0 0], []);
hold on;
plot.avgcdf(gca, valsWTSLO, [0 0 1], []);
title('Area HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pHDSvsWTS),'.'));
xlim([-3 9])
ylim([0 1])
subplot(1,2,2);
plot1 = plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot2 = plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
hold on;
plot3 = plot.avgcdf(gca, valsHDsNorm, [0 0 0], []);
hold on;
plot4 = plot.avgcdf(gca, valsWTSLONorm, [0 0 1], []);
title('Normalized area HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pNormHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pNormWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pNormHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pNormHDSvsWTS),'.'));
xlim([-3 9])
ylim([0 1])


