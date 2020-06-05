% 07/10/2019
% Author: QZ
% createBehavioralDB_QZ.m

miceIDs = unique({twdb(:).mouseID});
numMice = length(miceIDs);
% empty structs
ids = cell(numMice,1);
health = cell(numMice,1);
striosomality = cell(numMice,1);
learnedFirstTask = zeros(numMice,1);
tData = cell(numMice,1);
age = zeros(numMice,1);
rewardTone = zeros(numMice,1);
costTone = zeros(numMice,1);
index = zeros(numMice,1);
genotype = cell(numMice,1);
positive = zeros(numMice,1);
baseRTA = zeros(numMice,1);
baseRTS = zeros(numMice,1);
baseCTS = zeros(numMice,1);
% loop
for i = 1:numMice
    disp(['------' num2str(i) '------'])
    ids{i} = miceIDs{i};
    rows = twdb_lookup(twdb,'index','key','mouseID',miceIDs(i));
    mouseData = struct2table(twdb(cell2mat(rows)));
    sorted = sortMouseData_QZ(mouseData);
    health{i} = first(sorted.Health);
    striosomality{i} = first(sorted.intendedStriosomality);
    learnedFirstTask(i) = sorted.learnedFirstTask(1);
    age(i) = sorted.firstSessionAge(1);
    rewardTone(i) = sorted.rewardTone(1);
    costTone(i) = sorted.costTone(1);
    index(i) = i;
    genotype{i} = first(sorted.genotype);
    positive(i) = sorted.positive(1);
    % tData, fData (tables)
    this_Trials = sorted.trialData;
    StimulusID = [];
    ResponseLickFrequency = [];
    for j = 1:height(sorted)
%         disp(['~~~' num2str(j) '~~~'])
        if ~isempty(this_Trials{j})
            StimulusID = [StimulusID this_Trials{j}.StimulusID'];
            ResponseLickFrequency = [ResponseLickFrequency this_Trials{j}.ResponseLickFrequency'];
        else
            disp(['Empty trial data mouse ' miceIDs{i} ' session ' num2str(j)])
        end
    end
    tData{i} = table(StimulusID',ResponseLickFrequency','VariableNames',...
        {'StimulusID','ResponseLickFrequency'});
end