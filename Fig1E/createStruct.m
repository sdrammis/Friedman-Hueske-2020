%% Script that creates the structure you need!
% Author: QZ
% 06/10/2019
% createTable.m
function twdb = createStruct(twdb,age,health,learned,engagementFilt,photoFilt,cStats,noBaseFilt)
% does not modify the original data struct.
% param0  twdb  the database you're basing your analysis on
% param1  age  'all','young','mid','old'
% param2  health  'all','WT','HD'
% param3  learned  'all',true,false
% param4  engagementFilt  true,false
% param5  photoFilt  true,false
% param6  calcStats  true,false
%% filtering
% filter Emily's non-photometry animals
if noBaseFilt
    twdb = noBaseFilter(twdb);
end
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
    twdb = ageFilter(twdb,0,8); % REMEMBER TO CHANGE UB BACK TO 8!!!
elseif strcmp(age,'mid') == 1
    twdb = ageFilter(twdb,9,12);
elseif strcmp(age,'old') == 1
    twdb = ageFilter(twdb,13,inf);
end
% filter for engagement
if engagementFilt == true
    twdb = engagementFilter(twdb);
end
% calculate stats
if cStats == true
    twdb = calcStats(twdb);
end
end