function SurvivalAnalysis2tr(twdb)
%survival analysis with mean + 2STD threshold 

NonPtmID = {'2802', '2852', '2776', '2781', '2782', '2785', '2786', '2789', ...
    '2790', '2777', '2736', '2739', '2741', '2743' };

IDs = unique({twdb.mouseID});
LearnedID = {};
NotLearnedID = {};
for i = 1:length(IDs)
    ID = IDs(i);
    if ismember(ID, NonPtmID)
        continue
    end
    Learned = first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', ID));
    if Learned == -1
        NotLearnedID{end+1} = ID;
    end
    if Learned ~= -1
        LearnedID{end+1} = ID;
    end
end

TrialDataLearned = get_mouse_trials(twdb, LearnedID, true, false);
TrialDataNotLearned = get_mouse_trials(twdb, NotLearnedID, true, false);
TrialData = get_mouse_trials(twdb, IDs, true, false);

Learned_Trials = {};
for i = 1:length(TrialDataLearned)
    Learned_Trials{end+1} = size(TrialDataLearned{1,i}, 1);
end

NotLearned_Trials = {};
for i = 1:length(TrialDataNotLearned)
    NotLearned_Trials{end+1} = size(TrialDataNotLearned{1,i}, 1);
end

meanLearned = mean(cell2mat(Learned_Trials));
meanNotLearned = mean(cell2mat(NotLearned_Trials));
STDLearned = std(cell2mat(Learned_Trials));
STDNotLearned = std(cell2mat(NotLearned_Trials));

WTmiceYng = 0;
WTmiceMid = 0;
WTmiceOld = 0;
HDmiceYng = 0;
HDmiceMid = 0;
HDmiceOld = 0;

WTLearnedYng = 0;
WTLearnedMid = 0;
WTLearnedOld = 0;
HDLearnedYng = 0;
HDLearnedMid = 0;
HDLearnedOld = 0;

Filtered = {};
for i = 1:length(IDs)
    if ismember(IDs(i), NonPtmID)
        continue
    end
    age = first(twdb_lookup(twdb, 'firstSessionAge', 'key', 'mouseID', IDs(i)));
    genotype = first(twdb_lookup(twdb, 'Health', 'key', 'mouseID', IDs(i)));
    learned = first(twdb_lookup(twdb, 'learnedReversalTask', 'key', 'mouseID', IDs(i)));
  %  if learned == -1 && size(TrialData{1, i}, 1) < meanLearned 
       % Filtered{end+1} = IDs(i);
       % continue
    %end
    if strcmp(genotype, 'WT')
        if age<9
            WTmiceYng = WTmiceYng + 1;
            if learned ~= -1
                WTLearnedYng = WTLearnedYng + 1;
            end
        end
        if age>8 && age<13
            WTmiceMid = WTmiceMid + 1;
            if learned ~= -1
                WTLearnedMid = WTLearnedMid + 1;
            end
        end
        if age>12
            WTmiceOld = WTmiceOld + 1;
            if learned ~= -1
                WTLearnedOld = WTLearnedOld + 1;
            end
        end
    end
    if strcmp(genotype, 'HD')
        if age<9
            HDmiceYng = HDmiceYng + 1;
            if learned ~= -1
                HDLearnedYng = HDLearnedYng + 1;
            end
        end
        if age>8 && age<13
            HDmiceMid = HDmiceMid + 1;
            if learned ~= -1
                HDLearnedMid = HDLearnedMid + 1;
            end
        
        end
        if age>12
            HDmiceOld = HDmiceOld + 1;
            if learned ~= -1
                HDLearnedOld = HDLearnedOld + 1;
            end
            
        end
    end
end
WTPrcntYng = WTLearnedYng/WTmiceYng;
WTPrcntMid = WTLearnedMid/WTmiceMid;
WTPrcntOld = WTLearnedOld/WTmiceOld;
HDPrcntYng = HDLearnedYng/HDmiceYng;
HDPrcntMid = HDLearnedMid/HDmiceMid;
HDPrcntOld = HDLearnedOld/HDmiceOld;

WT_NL_Yng = WTmiceYng - WTLearnedYng;
WT_NL_Mid = WTmiceMid - WTLearnedMid;
WT_NL_Old = WTmiceOld - WTLearnedOld;
HD_NL_Yng = HDmiceYng - HDLearnedYng;
HD_NL_Mid = HDmiceMid - HDLearnedMid;
HD_NL_Old = HDmiceOld - HDLearnedOld;

barYData = [WTPrcntYng 1-WTPrcntYng; HDPrcntYng 1-HDPrcntYng; WTPrcntMid 1-WTPrcntMid; ...
    HDPrcntMid 1-HDPrcntMid; WTPrcntOld 1-WTPrcntOld; HDPrcntOld 1-HDPrcntOld];

textLabs = {sprintf('L=%d ,NL=%d', WTLearnedYng, WT_NL_Yng), ...
    sprintf('L=%d ,NL=%d', HDLearnedYng, HD_NL_Yng), ...
    sprintf('L=%d ,NL=%d', WTLearnedMid, WT_NL_Mid), ...
    sprintf('L=%d ,NL=%d', HDLearnedMid, HD_NL_Mid), ...
    sprintf('L=%d ,NL=%d', WTLearnedOld, WT_NL_Old), ...
    sprintf('L=%d ,NL=%d', HDLearnedOld, HD_NL_Old)};

titleStr = 'Two Tone Reversal Survival Analysis';
yLab = 'Percent Learned/Not Learned';
xLab = {'WT < 9 Months', 'HD < 9 Months', 'WT 9-12 Months', 'HD 9-12 Months', 'WT > 12 Months', 'HD > 12 Months'};
figure()
hold on
plotBarStacked(barYData,yLab,xLab,titleStr,textLabs)
hold off

n1 = [[WTLearnedYng, WT_NL_Yng];[HDLearnedYng, HD_NL_Yng]];
n2 = [[WTLearnedMid, WT_NL_Mid];[HDLearnedMid, HD_NL_Mid]];
n3 = [[WTLearnedOld, WT_NL_Old];[HDLearnedOld, HD_NL_Old]];

n4 = [[WTLearnedYng, WT_NL_Yng];[WTLearnedMid, WT_NL_Mid]];
n5 = [[WTLearnedYng, WT_NL_Yng];[WTLearnedOld, WT_NL_Old]];
n6 = [[WTLearnedMid, WT_NL_Mid];[WTLearnedOld, WT_NL_Old]];

n7 = [[HDLearnedYng, HD_NL_Yng];[HDLearnedMid, HD_NL_Mid]];
n8 = [[HDLearnedYng, HD_NL_Yng];[HDLearnedOld, HD_NL_Old]];
n9 = [[HDLearnedMid, HD_NL_Mid];[HDLearnedOld, HD_NL_Old]];

Yng_HD_vs_WT = dg_chi2test3(n1)
Mid_HD_vs_WT = dg_chi2test3(n2)
Old_HD_vs_WT = dg_chi2test3(n3)
WT_yng_vs_mid = dg_chi2test3(n4)
WT_yng_vs_old = dg_chi2test3(n5)
WT_mid_vs_old = dg_chi2test3(n6)
HD_yng_vs_mid = dg_chi2test3(n7)
HD_yng_vs_old = dg_chi2test3(n8)
HD_mid_vs_old = dg_chi2test3(n9)
