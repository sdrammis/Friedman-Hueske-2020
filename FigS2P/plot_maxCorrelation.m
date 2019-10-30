function plot_maxCorrelation(twdb,intendedStriosomality,health,learned,engagement)

reversal = 1;
miceIDs = get_mouse_ids(twdb,reversal,health,learned,intendedStriosomality,'all','all',1,{});

if ~isequal('all',learned) 
    if learned
        learned_str = 'learned';
    else 
        learned_str = 'not learned';
    end
else
    learned_str = 'all animals';
end

if ~isequal('all',engagement) 
    if engagement == 1
        engagement_str = 'engagedTrials';
    else
        engagement_str = 'notEngagedTrials';
    end
else
    engagement_str = 'allTrials';
end

R = dPrime_area_correlationOverTime(twdb,miceIDs,reversal,engagement,learned);
animalsR = cellfun(@max,R);
firstR = cellfun(@(v)v(1),R);

firstTask_R = dPrime_area_correlationOverTime(twdb,miceIDs,~reversal,engagement,learned);
animalsR_first = cellfun(@max,firstTask_R);
first_firstR = cellfun(@(v)v(1),firstTask_R);

[~,p_first] = ttest(animalsR_first);
[~,p_reversal] = ttest(animalsR);

[~,p_paired_first] = ttest(first_firstR,animalsR_first);
[~,p_paired_reversal] = ttest(firstR,animalsR);

figure
subplot(1,2,1)
hold on
parallelcoords([first_firstR' animalsR_first'])
set(gca,'XTickLabel',{'First','Max'},'XTick',1:2);
ylabel('R')
title({'First Task',['Max: p=' num2str(p_first)],['Paired: p=' num2str(p_paired_first)]})

subplot(1,2,2)
hold on
parallelcoords([firstR' animalsR'])
set(gca,'XTickLabel',{'First','Max'},'XTick',1:2);
ylabel('R')
title({'Reversal Task',['Max: p=' num2str(p_reversal)],['Paired: p=' num2str(p_paired_reversal)]})


title_str = [intendedStriosomality ' ' health ' ' learned_str, ' ', engagement_str];
supertitle({title_str,'',''})


