dreaddInhbIDXs = strcmp({miceType.DREADDType}, 'Inhibitory');
dreaddExctIDXs = strcmp({miceType.DREADDType}, 'Excitatory');

miceInhbDREADD = miceType(dreaddInhbIDXs);
miceExctDREADD = miceType(dreaddExctIDXs);

groupsInhb = get_groups(twdb, miceInhbDREADD);
groupsExct = get_groups(twdb, miceExctDREADD);

gradesInhb = minimax_norm(groupsInhb.SpikeRateDiff);
groupsInhb.Grades = gradesInhb;
gradesExct = minimax_norm(groupsExct.SpikeRateDiff);
groupsExct.Grades = gradesExct;
groups = [groupsInhb; groupsExct];
groups.MouseID = str2double(groups.MouseID);
save('./dreaddgroups.mat', 'groups', '-v7.3');

function groups = get_groups(twdb, mice)
NO_TRANSIENTS = { ...
    '215', '225', '226', '231', '249', '267', '272', '279', '282', '309', ...
    '316', '4359', '4361', '4362', '4364', '4370', '4779', '4781', '4783', ...
    };

varNames = {'MouseID', 'SpikesHZ', 'TaskTypes', 'SessionNums', ...
    'SessionNumCNO', 'SessionNumSaline', 'ConctrCNO', 'SpikeRateDiff', ...
    'Effect', 'hasTransients'};
groups = table({''}, {[]}, {[]}, {[]}, 0, 0, 0, 0, {''}, -1, 'VariableNames', varNames);
for ii=1:length(mice)
    ii
    mouse = mice(ii);
    try
        [nSpikes, spikeTimes, sessions] = get_mouse_spikes(twdb, mouse.ID);
    catch
        fprintf('Mouse %s FAILED!!!\n', mouse.ID);
        continue;
    end
    cal = calendarize(nSpikes, spikeTimes, sessions);
    groups_ = analyze_mouse(cal, mouse.ID, mouse.DREADDType);
    groups_.hasTransients = repmat(~any(strcmp(mouse.ID, NO_TRANSIENTS)), size(groups_,1),1);
    groups = [groups; groups_];
end
groups(1,:) = [];
end

function ret = minimax_norm(A)
ret = (A - min(A)) ./ (max(A) - min(A));
end
