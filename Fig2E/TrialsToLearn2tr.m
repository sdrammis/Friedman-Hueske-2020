function TrialsToLearn2tr(twdb)

%trials to learn 2tr
%7/8/19 Kaden DiMarco

NonPtmID = {'2802', '2852', '2776', '2781', '2782', '2785', '2786', '2789', ...
    '2790', '2777', '2736', '2739', '2741', '2743' };

IDs = unique({twdb.mouseID});

WTYngMice = unique(twdb_lookup(twdb, 'mouseID', 'key', 'Health', 'WT', 'grade', 'firstSessionAge', 0,8));
WTMidMice = unique(twdb_lookup(twdb, 'mouseID', 'key', 'Health', 'WT', 'grade', 'firstSessionAge', 9,12));
WTOldMice = unique(twdb_lookup(twdb, 'mouseID', 'key', 'Health', 'WT', 'grade', 'firstSessionAge', 13,inf));
HDYngMice = unique(twdb_lookup(twdb, 'mouseID', 'key', 'Health', 'HD', 'grade', 'firstSessionAge', 0,8));
HDMidMice = unique(twdb_lookup(twdb, 'mouseID', 'key', 'Health', 'HD', 'grade', 'firstSessionAge', 9,12));
HDOldMice = unique(twdb_lookup(twdb, 'mouseID', 'key', 'Health', 'HD', 'grade', 'firstSessionAge', 13,inf));

WTYngMiceLearned = {};
for i = 1:length(WTYngMice)
    if first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', WTYngMice{i})) ~= -1 && ~ismember(WTYngMice{i}, NonPtmID)
        WTYngMiceLearned{end+1} = WTYngMice(i);
    end
end

WTMidMiceLearned = {};
for i = 1:length(WTMidMice)
    if first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', WTMidMice(i))) ~= -1 && ~ismember(WTMidMice{i}, NonPtmID)
        WTMidMiceLearned{end+1} = WTMidMice(i);
    end
end

WTOldMiceLearned = {};
for i = 1:length(WTOldMice)
    if first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', WTOldMice(i))) ~= -1 && ~ismember(WTOldMice{i}, NonPtmID)
        WTOldMiceLearned{end+1} = WTOldMice(i);
    end
end

HDYngMiceLearned = {};
for i = 1:length(HDYngMice)
    if first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', HDYngMice(i))) ~= -1 && ~ismember(HDYngMice{i}, NonPtmID)
        HDYngMiceLearned{end+1} = HDYngMice(i);
    end
end

HDMidMiceLearned = {};
for i = 1:length(HDMidMice)
    if first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', HDMidMice(i))) ~= -1 && ~ismember(HDMidMice{i}, NonPtmID)
        HDMidMiceLearned{end+1} = HDMidMice(i);
    end
end

HDOldMiceLearned = {};
for i = 1:length(HDOldMice)
    if first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', HDOldMice(i))) ~= -1 && ~ismember(HDOldMice{i}, NonPtmID)
        HDOldMiceLearned{end+1} = HDOldMice(i);
    end
end



WTYngTrialsRaw = get_mouse_trials_2(twdb, WTYngMiceLearned, true, false);
WTMidTrialsRaw = get_mouse_trials_2(twdb, WTMidMiceLearned, true, false);
WTOldTrialsRaw = get_mouse_trials_2(twdb, WTOldMiceLearned, true, false);
HDYngTrialsRaw = get_mouse_trials_2(twdb, HDYngMiceLearned, true, false);
HDMidTrialsRaw = get_mouse_trials_2(twdb, HDMidMiceLearned, true, false);
HDOldTrialsRaw = get_mouse_trials_2(twdb, HDOldMiceLearned, true, false);

WTYngTrials = {};
WTMidTrials = {};
WTOldTrials = {};
HDYngTrials = {};
HDMidTrials = {};
HDOldTrials = {};

for i = 1:length(WTYngTrialsRaw)
    WTYngTrials{end+1} = size(WTYngTrialsRaw{1,i}, 1);
end
for i = 1:length(WTMidTrialsRaw)
    WTMidTrials{end+1} = size(WTMidTrialsRaw{1,i}, 1);
end
for i = 1:length(WTOldTrialsRaw)
    WTOldTrials{end+1} = size(WTOldTrialsRaw{1,i}, 1);
end
for i = 1:length(HDYngTrialsRaw)
    HDYngTrials{end+1} = size(HDYngTrialsRaw{1,i}, 1);
end
for i = 1:length(HDMidTrialsRaw)
    HDMidTrials{end+1} = size(HDMidTrialsRaw{1,i}, 1);
end
for i = 1:length(HDOldTrialsRaw)
    HDOldTrials{end+1} = size(HDOldTrialsRaw{1,i}, 1);
end

barYData = {cell2mat(WTYngTrials), cell2mat(HDYngTrials), cell2mat(WTMidTrials), cell2mat(HDMidTrials), cell2mat(WTOldTrials), cell2mat(HDOldTrials)};

AllTrials = horzcat(WTYngTrials, HDYngTrials, WTMidTrials, HDMidTrials, WTOldTrials, HDOldTrials);
ttrSTD = std(cell2mat(AllTrials))
ttrMean = mean(cell2mat(AllTrials))

xLab = {'WT < 9 Months', 'HD < 9 Months', 'WT 9-12 Months', 'HD 9-12 Months', 'WT > 12 Months', 'HD > 12 Months'};
       
yLab = 'Trials';

titleStr = 'Number of trials to learn 2tr';
%plots number of trials per cohort
figure()
hold on
plotBar(barYData,yLab,xLab,titleStr)
hold off