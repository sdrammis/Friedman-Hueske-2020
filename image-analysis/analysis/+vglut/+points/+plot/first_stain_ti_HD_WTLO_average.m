%% load mat files
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiHDm.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiWTMLO.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiHDs.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiWTSLO.mat')

% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiHDmNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiWTMLONorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiHDsNorm.mat')
% load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\tiWTSLONorm.mat')

load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\allMiceTotalInt.mat')
load('C:\Users\Alexander\sabrina-workspace\striomatrix-cv\analysis\+vglut\+points\+compute\resamp_first_stain\stdTotalIntensityArr.mat')
%% Normalization factors
allMiceAreaInt = allMiceTotalInt;
stdArr = stdTotalIntensityArr;

%% read in first stain data and prefrom normalization for HDs, HDm, WTs and WTm 
valsWTMLO = {};
names = tiWTMLO.Properties.VariableNames;
for col = 1:size(tiWTMLO,2)
    if contains(names{col}, '2018')
        valsWTMLO = [valsWTMLO tiWTMLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTMLONorm = cell2mat(valsWTMLO)';
valsWTMLONormArr = (valsWTMLONorm - allMiceAreaInt) / stdArr;
reshapedArrWTMLO = reshape(valsWTMLONormArr, [1000 12]);
valsWTMLONorm = num2cell(reshapedArrWTMLO, [1 12]);


valsHDm = {};
names = tiHDm.Properties.VariableNames;
for col = 1:size(tiHDm,2)
    if contains(names{col}, '2018')
        valsHDm = [valsHDm tiHDm{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDmNorm = cell2mat(valsHDm)';
valsHDmNormArr = (valsHDmNorm - allMiceAreaInt) / stdArr;
reshapedArrHDm = reshape(valsHDmNormArr, [1000 16]);
valsHDmNorm = num2cell(reshapedArrHDm, [1 16]);


%read in first stain data
valsWTSLO = {};
names = tiWTSLO.Properties.VariableNames;
for col = 1:size(tiWTSLO,2)
    if contains(names{col}, '2018')
        valsWTSLO = [valsWTSLO tiWTSLO{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsWTSLONorm = cell2mat(valsWTSLO)';
valsWTSLONormArr = (valsWTSLONorm - allMiceAreaInt) / stdArr;
reshapedArrWTSLO = reshape(valsWTSLONormArr, [1000 12]);
valsWTSLONorm = num2cell(reshapedArrWTSLO, [1 12]);


valsHDs = {};
names = tiHDs.Properties.VariableNames;
for col = 1:size(tiHDs,2)
    if contains(names{col}, '2018')
        valsHDs = [valsHDs tiHDs{:,col}'];
    else
        fprintf('filtered out %s \n', names{col});
    end
end
valsHDsNorm = cell2mat(valsHDs)';
valsHDsNormArr = (valsHDsNorm - allMiceAreaInt) / stdArr;
reshapedArrHDs = reshape(valsHDsNormArr, [1000 16]);
valsHDsNorm = num2cell(reshapedArrHDs, [1 16]);


%% Original method of Normalization. To use this, you must uncomment the load statments at the top as well.

% valsWTSLONorm = {};
% names = tiWTSLONorm.Properties.VariableNames;
% for col = 1:size(tiWTSLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTSLONorm = [valsWTSLONorm tiWTSLONorm{:,col}'];
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
% 
valsHDsArr = cell2mat(valsHDs)';
valsWTSLOArr = cell2mat(valsWTSLO)';
% valsHDsNormArr = cell2mat(valsHDsNorm)';
% valsWTSLONormArr = cell2mat(valsWTSLONorm)';
% 
% 
% valsWTMLONorm = {};
% names = tiWTMLONorm.Properties.VariableNames;
% for col = 1:size(tiWTMLONorm,2)
%     if contains(names{col}, '2018')
%         valsWTMLONorm = [valsWTMLONorm tiWTMLONorm{:,col}'];
%     else
%         fprintf('filtered out %s \n', names{col});
%     end
% end
% 
% valsHDmNorm = {};
% names = tiHDmNorm.Properties.VariableNames;
% for col = 1:size(tiHDmNorm,2)
%     if contains(names{col}, '2018')
%         valsHDmNorm = [valsHDmNorm tiHDmNorm{:,col}'];
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
% save('reshapedArrHDsti.mat','reshapedArrHDs');
% save('reshapedArrHDmti.mat','reshapedArrHDm');
% save('reshapedArrWTSLOti.mat','reshapedArrWTSLO');
% save('reshapedArrWTMLOti.mat','reshapedArrWTMLO');
%% Exports normalized resampled data in single cloumn format
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\VGluT_Particles_ZscoreAcrossWholePopBetterNorm_concatenatedFormat')
% save('valsHDsNormArrTi.mat','valsHDsNormArr');
% save('valsHDmNormArrTi.mat','valsHDmNormArr');
% save('valsWTSLONormArrTi.mat','valsWTSLONormArr');
% save('valsWTMLONormArrTi.mat','valsWTMLONormArr');
%% Exports not normalized resampled data in single cloumn format
% cd('D:\Dropbox (MIT)\CHDI Database Codes\Emily HD Histo Test Set\VGluT analyses\VGluT Particle Analysis\EMPTY VGluT_Particles_ZscoreAcrossWithinSection_concatenatedFormat\Raw')
% save('valsHDsArrTi.mat','valsHDsArr');
% save('valsHDmArrTi.mat','valsHDmArr');
% save('valsWTSLOArrTi.mat','valsWTSLOArr');
% save('valsWTMLOArrTi.mat','valsWTMLOArr');
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
title('Total intensity HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pHDSvsWTS),'.'));
% ylim([0 1.1])
subplot(1,2,2);
plot1 = plot.avgcdf(gca, valsHDmNorm, [1 0 0], []);
hold on;
plot2 = plot.avgcdf(gca, valsWTMLONorm, [0 1 0], []);
hold on;
plot3 = plot.avgcdf(gca, valsHDsNorm, [0 0 0], []);
hold on;
plot4 = plot.avgcdf(gca, valsWTSLONorm, [0 0 1], []);
title('Normalized total intensity HD vs. WT old learned.');
legend('Standard error HD matrix distribution.', strcat('Average HD matrix values. KS val; HD matrix vs. WT matrix = ', num2str(pNormHDMvsWTM),'.'), ...
    'Standard error WT matrix distribution.', strcat('Average WT matrix values. KS val; WT strio vs. WT matrix = ', num2str(pNormWTSvsWTM), '.'), ...
    'Standard error HD strio distribution.', strcat('Average HD strio values. KS val; HD strio vs. HD matrix = ', num2str(pNormHDSvsHDM),'.'), ...
    'Standard error WT strio distribution.', strcat('Average WT strio values. KS val; HD strio vs. WT strio = ', num2str(pNormHDSvsWTS),'.'));
% ylim([0 1.1])

