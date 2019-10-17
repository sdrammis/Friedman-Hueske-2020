function [dzp1,dzp2,dzp3] = dzp_table(twdb)

% Author: QZ
% Date: 06/17/2019
% dzp_table.m
%% Load Data
% twdb = load('light_twdb_2019-06-06.mat');
% twdb = twdb.twdb;
%% Create tables
dzp1 = make_dzp_table(twdb,1);
% save('dzp_conc_1.mat','dzp1');
dzp2 = make_dzp_table(twdb,0.5);
% save('dzp_conc_0point5.mat','dzp2');
dzp2.sessionDate{end} = "";
dzp2.sessionDay{end} = "";
rmIdxs = 60;
dzp2.DP1(rmIdxs) = NaN;
dzp2.DP2(rmIdxs) = NaN;
dzp2.DP3(rmIdxs) = NaN;
dzp2.TPR1(rmIdxs) = NaN;
dzp2.TPR2(rmIdxs) = NaN;
dzp2.TPR3(rmIdxs) = NaN;
dzp2.FPR1(rmIdxs) = NaN;
dzp2.FPR2(rmIdxs) = NaN;
dzp2.FPR3(rmIdxs) = NaN;
dzp2.C1(rmIdxs) = NaN;
dzp2.C2(rmIdxs) = NaN;
dzp2.C3(rmIdxs) = NaN;
dzp2.LRr(rmIdxs) = NaN;
dzp2.LRc(rmIdxs) = NaN;
dzp3 = make_dzp_table(twdb,0.35);
% save('dzp_conc_0point35.mat','dzp3');