function SurvivalAnalysisFirstTask_(twdb)

ageRanges = {[0 8],[9 12],[13 Inf]};
healths = {'WT','WT'};
striosomalities = {'Strio','Matrix'};
photometry = 'all';
exceptions  = {'2802', '2852', '2776', '2781', '2782', '2785', '2786', '2789', ...
'2790', '2777', '2736', '2739', '2741', '2743' };

type1 = {};
type2 = {};

figure
hold on
for a = 1:length(ageRanges)
    ageRange = ageRanges{a};
    mouseIDs_type1 = get_mouse_ids(twdb,0,healths{1},'all',striosomalities{1},'all',ageRange,photometry,exceptions);
    learned_mouseIDs_type1 = get_mouse_ids(twdb,0,healths{1},1,striosomalities{1},'all',ageRange,photometry,exceptions);
    
    mouseIDs_type2 = get_mouse_ids(twdb,0,healths{2},'all',striosomalities{2},'all',ageRange,photometry,exceptions);
    learned_mouseIDs_type2 = get_mouse_ids(twdb,0,healths{2},1,striosomalities{2},'all',ageRange,photometry,exceptions);
    
    type1{a} = [length(learned_mouseIDs_type1) length(mouseIDs_type1)-length(learned_mouseIDs_type1)];
    type2{a} = [length(learned_mouseIDs_type2) length(mouseIDs_type2)-length(learned_mouseIDs_type2)];
    
    bar([2*a-1 2*a],[1 1],'FaceColor',[0.5 0.5 0.5])
    bar([2*a-1 2*a],[length(learned_mouseIDs_type1)/length(mouseIDs_type1) length(learned_mouseIDs_type2)/length(mouseIDs_type2)],'FaceColor','c')
    
    text(2*a-1.05,0.95,num2str(length(mouseIDs_type1)-length(learned_mouseIDs_type1)),'FontSize',20)
    text(2*a-1.05,0.05,num2str(length(learned_mouseIDs_type1)),'FontSize',20)
    
    text(2*a-0.05,0.95,num2str(length(mouseIDs_type2)-length(learned_mouseIDs_type2)),'FontSize',20)
    text(2*a-0.05,0.05,num2str(length(learned_mouseIDs_type2)),'FontSize',20)
    
end

xlab_type1 = [healths{1} ' ' striosomalities{1}];
xlab_type2 = [healths{2} ' ' striosomalities{2}];
xLab = {[xlab_type1 ' < 9 Months'], [xlab_type2 ' < 9 Months'], [xlab_type1 ' 9-12 Months'], [xlab_type2 ' 9-12 Months'], [xlab_type1 ' > 12 Months'], [xlab_type2 ' > 12 Months']};
set(gca,'XTickLabel',xLab,'XTick',1:numel(xLab));
xtickangle(45);
ylabel('Proportion of Mice')
title('First Task Survival Analysis')

Yng_type1_vs_type2 = dg_chi2test3([type1{1}; type2{1}]);
Mid_type1_vs_type2 = dg_chi2test3([type1{2}; type2{2}]);
Old_type1_vs_type2 = dg_chi2test3([type1{3}; type2{3}]);
type2_yng_vs_mid = dg_chi2test3([type2{1}; type2{2}]);
type2_yng_vs_old = dg_chi2test3([type2{1}; type2{3}]);
type2_mid_vs_old = dg_chi2test3([type2{2}; type2{3}]);
type1_yng_vs_mid = dg_chi2test3([type1{1}; type1{2}]);
type1_yng_vs_old = dg_chi2test3([type1{1}; type1{3}]);
type1_mid_vs_old = dg_chi2test3([type1{2}; type1{3}]);

[xlab_type1 ' vs ' xlab_type2 ' < 9 Months: ' num2str(Yng_type1_vs_type2)]
[xlab_type1 ' vs ' xlab_type2 ' 9-12 Months: ' num2str(Mid_type1_vs_type2)]
[xlab_type1 ' vs ' xlab_type2 ' > 12 Months: ' num2str(Old_type1_vs_type2)]
[xlab_type2 ' < 9 vs 9-12 Months: ' num2str(type2_yng_vs_mid)]
[xlab_type2 ' < 9 vs > 12 Months: ' num2str(type2_yng_vs_old)]
[xlab_type2 ' 9-12 vs > 12 Months: ' num2str(type2_mid_vs_old)]
[xlab_type1 ' < 9 vs 9-12 Months: ' num2str(type1_yng_vs_mid)]
[xlab_type1 ' < 9 vs > 12 Months: ' num2str(type1_yng_vs_old)]
[xlab_type1 ' 9-12 vs > 12 Months: ' num2str(type1_mid_vs_old)]

end