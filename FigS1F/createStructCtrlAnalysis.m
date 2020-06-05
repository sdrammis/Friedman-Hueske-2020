%% Script that creates the structure you need!
% Author: QZ
% 06/11/2019
% createStructCtrlAnalysis.m
function twdb = createStructCtrlAnalysis(twdb,age,health,learned,photoFilt)
% does not modify the original data struct.
% param1  twdb  the database you're basing your analysis on
% param2  age  'all','young','mid','old'
% param3  health  'all','WT','HD'
% param4  learned  'all',true (learn),false (don't learn)
% param5  photoFilt  true(filter Emily's animals),false (don't filter)
%% filtering
% filter Emily's non-photometry animals
if photoFilt == true
    twdb = EmilyPhotometryFilter(twdb);
end
% filter for learning
if learned == true
    twdb = LearnedFilter(twdb,true);
elseif learned == false
    twdb = LearnedFilter(twdb,false);
end
% filter for health
if strcmp(health,'WT') == 1
    twdb = HealthFilter(twdb,'WT');
elseif strcmp(health,'HD') == 1
    twdb = HealthFilter(twdb,'HD');
end
% filter for age
if strcmp(age,'young') == 1
    twdb = ageFilter(twdb,0,8);
elseif strcmp(age,'mid') == 1
    twdb = ageFilter(twdb,9,12);
elseif strcmp(age,'old') == 1
    twdb = ageFilter(twdb,13,inf);
end
end