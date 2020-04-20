dreaddInhbIDXs = strcmp({miceType.DREADDType}, 'Inhibitory');
dreaddExctIDXs = strcmp({miceType.DREADDType}, 'Excitatory');
dreaddMCherryIDXs = strcmp({miceType.DREADDType}, 'mCherry');

miceInhbDREADD = miceType(dreaddInhbIDXs);
miceExctDREADD = miceType(dreaddExctIDXs);
miceMCherryDREADD = miceType(dreaddMCherryIDXs);

groupsInhb = get_groups(twdb, miceInhbDREADD);
groupsExct = get_groups(twdb, miceExctDREADD);
groupsMCherry = get_groups(twdb, miceMCherryDREADD);

gradesInhb = minimax_norm(groupsInhb.SpikeRateDiff);
groupsInhb.Grades = gradesInhb;
gradesExct = minimax_norm(groupsExct.SpikeRateDiff);
groupsExct.Grades = gradesExct;
gradesMCherry = minimax_norm(groupsMCherry.SpikeRateDiff);
groupsMCherry.Grades = gradesMCherry;
groups = [groupsInhb; groupsExct; groupsMCherry];
groups.MouseID = str2double(groups.MouseID);
save('./dreaddgroups.mat', 'groups', '-v7.3');

function groups = get_groups(twdb, mice)
NO_TRANSIENTS = { ...
    '215', '225', '231', '249', '259', '267', '279', '282', '316', ...
    '352', '353', '3271', '3575', '3576', '3709', '4098', '4359', ...
    '4361', '4364', '4369', '4447', '4452', '4455', '4581', '4639', ...
    '4643', '4781', '4783', '4867', '4915', '4957', ...
    };

varNames = {'MouseID', 'SpikesHZ', 'SpikesGrades', 'SessionsTimes', 'TaskTypes', 'SessionNums', ...
    'SessionNumCNO', 'SessionNumSaline', 'ConctrCNO', 'SpikeRateDiff', ...
    'Effect', 'hasTransients'};
groups = table({''}, {[]}, {[]}, 0, {[]}, {[]}, 0, 0, 0, 0, {''}, -1, 'VariableNames', varNames);
for ii=1:length(mice)
    ii
    mouse = mice(ii);
    
    try
        [nSpikes, spikeTimes, sessions, spikesGrades] = get_mouse_spikes(twdb, mouse.ID);
    catch
        fprintf('Mouse %s FAILED!!!\n', mouse.ID);
        continue;
    end
    
    cal = calendarize(nSpikes, spikeTimes, sessions, spikesGrades);
    groups_ = analyze_mouse(cal, mouse.ID, mouse.DREADDType);
    groups_.hasTransients = repmat(~any(strcmp(mouse.ID, NO_TRANSIENTS)), size(groups_,1),1);
    groups = [groups; groups_];
end
groups(1,:) = [];
end

function ret = minimax_norm(A)
ret = (A - min(A)) ./ (max(A) - min(A));
end
