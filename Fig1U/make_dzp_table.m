% Author: QZ
% 06/18/2019
% WARNING: has its limits. Assumes saline before and after are straight
% before and after the DZP trial. In the case of 4199, there was no trial
% for DZP after. Had to manually modify table
function new_table = make_dzp_table(twdb,concentration)
% mouseID
ids = unique(twdb_lookup(twdb,'mouseID','key','injection','Diazepam',...
    'key','concentration',concentration)); % change concentration as needed to create different tables
% sessionType
sessionTypes = {'Saline Before','Diazepam','Saline After'};
numMice = length(ids);
totNum = 3*numMice;
sessionType = cell(1,totNum)';
sessionDate = cell(1,totNum)';
sessionDay = cell(1,totNum)';
DP1 = zeros(1,totNum)';
DP2 = zeros(1,totNum)';
DP3 = zeros(1,totNum)';
TPR1 = zeros(1,totNum)';
TPR2 = zeros(1,totNum)';
TPR3 = zeros(1,totNum)';
FPR1 = zeros(1,totNum)';
FPR2 = zeros(1,totNum)';
FPR3 = zeros(1,totNum)';
C1 = zeros(1,totNum)';
C2 = zeros(1,totNum)';
C3 = zeros(1,totNum)';
LRr = zeros(1,totNum)';
LRc = zeros(1,totNum)';
mouseID = cell(1,totNum)';
intendedStriosomality = cell(1,totNum)';
health = cell(1,totNum)';
genotype = cell(1,totNum)';
positive = zeros(1,totNum)';
index = (1:totNum)';
% birthDate = cell(1,totNum)';
DREADDType = cell(1,totNum)';
for i = 1:numMice
%     disp('------------------');
    dzpRow = first(twdb_lookup(twdb,'index','key','mouseID',ids{i},...
        'key','injection','Diazepam','key','concentration',concentration));
%     disp(['dzp row: ' num2str(dzpRow)]);
    twdbIDs = (dzpRow-1):(dzpRow+1);
    if strcmp(ids{i},'4199')
        twdbIDs(3) = 8090;
    end
    tableIDs = (3*i-2):3*i;
    for j = 1:3
%         disp('~~~~~~~~~~~~~~~~~~~~~~');
        datID = twdbIDs(j);
        tabID = tableIDs(j);
%         disp(['twdb row: ',num2str(datID)]);
%         disp(['table row: ',num2str(tabID)]);
        % mouseID
        mouseID{tabID} = ids(i);
        % date, day, birthDate, DREADDType
        date = twdb_lookup(twdb,'sessionDate','key','index',datID);
        sessionDate{tabID} = date;
        [~,name] = weekday(date);
        sessionDay{tabID} = name;
%         birthDate{tabID} = twdb(datID).birthDate;
        DREADDType{tabID} = twdb(datID).DREADDType;
        % sessionType
        sessionType{tabID} = sessionTypes{j};
        % stats
        % tD = twdb(datID).trialData;
        [rLicks, cLicks] = get_r_and_c_licks(twdb,datID);
        [tpr1, fpr1, dp1, c1] = dprime_and_c_licks(rLicks,cLicks);
        [tpr2, fpr2, dp2, c2] = dprime_and_c_licks2(rLicks,cLicks);
        [tpr3, fpr3, dp3, c3] = dprime_and_c_licks3(rLicks,cLicks);
%         disp(tpr1);
        DP1(tabID) = dp1;
        DP2(tabID) = dp2;
        DP3(tabID) = dp3;
        TPR1(tabID) = tpr1;
        TPR2(tabID) = tpr2;
        TPR3(tabID) = tpr3;
        FPR1(tabID) = fpr1;
        FPR2(tabID) = fpr2;
        FPR3(tabID) = fpr3;
        C1(tabID) = c1;
        C2(tabID) = c2;
        C3(tabID) = c3;
        LRr(tabID) = mean(rLicks);
        LRc(tabID) = mean(cLicks);
        % intendedStriosomality, health, genotype, positive
        intendedStriosomality{tabID} = twdb(datID).intendedStriosomality;
        health{tabID} = twdb(datID).Health;
        genotype{tabID} = twdb(datID).genotype;
        positive(tabID) = twdb(datID).positive;
    end
end
% assign indices?
%all_ids = {twdb.mouseID};
%ids = unique(all_ids);
%% Create and save table
new_table = table(mouseID,sessionType,sessionDate,sessionDay,...
    intendedStriosomality,health,genotype,positive,DREADDType,...
    DP1,DP2,DP3,TPR1,TPR2,TPR3,FPR1,FPR2,FPR3,C1,C2,C3,LRr,LRc,index);
end