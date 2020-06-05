function SurvivalAnalysisFirstTask(twdb)

ageRanges = {[0 8],[9 12],[13 Inf]};
healths = {'WT','WT'};
striosomalities = {'Strio','Matrix'};
photometry = 'all';
exceptions  = {'2802', '2852', '2776', '2781', '2782', '2785', '2786', '2789', ...
'2790', '2777', '2736', '2739', '2741', '2743' };

figure
hold on
for a = 1:length(ageRanges)
    ageRange = ageRanges{a};
    mouseIDs_type1 = get_mouse_ids(twdb,0,healths{1},1,striosomalities{1},'all',ageRange,photometry,exceptions);
    learningTrials_type1 = getLearningTrials(twdb,mouseIDs_type1);
    
    mouseIDs_type2 = get_mouse_ids(twdb,0,healths{2},1,striosomalities{2},'all',ageRange,photometry,exceptions);
    learningTrials_type2 = getLearningTrials(twdb,mouseIDs_type2);
     
    bar([2*a-1 2*a],[nanmean(learningTrials_type1) nanmean(learningTrials_type2)],'FaceColor',[0.5 0.5 0.5])
    errorbar([2*a-1 2*a],[nanmean(learningTrials_type1) nanmean(learningTrials_type2)],[std_error(learningTrials_type1) std_error(learningTrials_type2)],'.k')
    
    text(2*a-1.05,100,num2str(length(mouseIDs_type1)),'FontSize',20)
    text(2*a-0.05,100,num2str(length(mouseIDs_type2)),'FontSize',20)
    
    plot((2*a-1.25)*ones(length(learningTrials_type1),1),learningTrials_type1,'ko')
    plot((2*a-0.25)*ones(length(learningTrials_type2),1),learningTrials_type2,'ko')
    
end

xlab_type1 = [healths{1} ' ' striosomalities{1}];
xlab_type2 = [healths{2} ' ' striosomalities{2}];
xLab = {[xlab_type1 ' < 9 Months'], [xlab_type2 ' < 9 Months'], [xlab_type1 ' 9-12 Months'], [xlab_type2 ' 9-12 Months'], [xlab_type1 ' > 12 Months'], [xlab_type2 ' > 12 Months']};
set(gca,'XTickLabel',xLab,'XTick',1:numel(xLab));
xtickangle(45);
ylabel('Number of Trials for Learning')
title('First Task Survival Analysis')

end
