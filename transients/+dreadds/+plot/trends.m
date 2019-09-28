STRIOSOMALITY = 'Strio';
HEALTH = 'WT';
CNO_EXCT = [0.3 1]; % Remove 0.6 to match wit Sebastian
CNO_INHB = [0.3 0.6 1];

strioWTIDXs = strcmp({miceType.Health}, HEALTH) & strcmp({miceType.intendedStriosomality}, STRIOSOMALITY);
dreaddInhbIDXs = strcmp({miceType.DREADDType}, 'Inhibitory') & strioWTIDXs;
dreaddExctIDXs = strcmp({miceType.DREADDType}, 'Excitatory') & strioWTIDXs;

miceInhbDREADD = miceType(dreaddInhbIDXs);
miceExctDREADD = miceType(dreaddExctIDXs);

dreaddType = 'EXCT'; % CHANGE THIS TO RUN DESIRED DREADD GROUP!
if strcmp(dreaddType, 'EXCT')
    cnoVals = CNO_EXCT;
    mice = miceExctDREADD;
else
   cnoVals = CNO_INHB;
   mice = miceInhbDREADD;
end

spikes = [];
dprimes = [];
cs = [];

idxs = {};
for ii=1:length(mice)
    mouse = mice(ii);
    mouseGroups = groups(strcmp(groups.MouseID, mouse.ID),:);
    for jj=1:size(mouseGroups,1)
        mouseGroup = mouseGroups(jj,:);
        if isempty(mouseGroup) || ~mouseGroup.hasTransients
            continue;
        end
        
        if sum(mouseGroup.ConctrCNO{1} == cnoVals) == 0
            continue;
        end
        
        idxs{end+1} = mouse.ID;
        [spikes_, dprimes_, cs_] = process_group(twdb, mouse.ID, mouseGroup);
        spikes = [spikes; spikes_];
        dprimes = [dprimes; dprimes_];
        cs = [cs; cs_];
    end
end

f = figure;
subplot(1,3,1);
plot_(spikes);
title('Spikes');
subplot(1,3,2);
plot_(dprimes);
title('D-Prime');
subplot(1,3,3);
plot_(cs);
title('C');

function plot_(A)
hold on;
for k=1:size(A,1)
    plot([1 2],A(k,:),'k*-');
end
xticks([1 2])
xticklabels({'Saline', 'CNO'})
xlim([.5 2.5]);
end

function [spikes, dprimes, cs] = process_group(twdb, mouseID, group)
spikes = [];
dprimes = [];
cs = [];

sessionNums = cell2mat(group.SessionNums{1});
grpIdxSaline = sessionNums == group.SessionNumSaline{1};
grpIdxCNO = sessionNums == group.SessionNumCNO{1};
spikesSaline = group.SpikesHZ{1}(grpIdxSaline);
spikesCNO = group.SpikesHZ{1}(grpIdxCNO);

dbIdxSaline = twdb_lookup(twdb, 'index', ...
    'key', 'mouseID', mouseID, ...
    'key', 'taskType', group.TaskTypes{1}{grpIdxSaline}, ...
    'key', 'sessionNumber', group.SessionNumSaline{1});
dbIdxCNO = twdb_lookup(twdb, 'index', ...
    'key', 'mouseID', mouseID, ...
    'key', 'taskType', group.TaskTypes{1}{grpIdxCNO}, ...
    'key', 'sessionNumber', group.SessionNumCNO{1});
rowSaline = twdb(dbIdxSaline{1});
rowCNO = twdb(dbIdxCNO{1});

if ~isempty(rowCNO.devaluation)
    sprintf('Filtered out a deval!\n');
    return;
end

trialDataSaline = rowSaline.trialData;
trialDataSaline.LicksInResponse = trialDataSaline.ResponseLickFrequency;
[~, ~, dpSaline, cSaline] = utils.dprime_and_c(trialDataSaline, rowSaline.rewardTone, rowSaline.costTone);
trialDataCNO = rowCNO.trialData;
trialDataCNO.LicksInResponse = trialDataCNO.ResponseLickFrequency;
[~, ~, dpCNO, cCNO] = utils.dprime_and_c(trialDataCNO, rowCNO.rewardTone, rowCNO.costTone);

spikes = [spikesSaline spikesCNO];
dprimes = [dpSaline dpCNO];
cs = [cSaline cCNO];
end