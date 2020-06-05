function correlationOverTime_reversal(twdb,miceIDs,intendedStriosomality,health,learned,engagement)
    
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
    title_str = [intendedStriosomality ' ' health ' ' learned_str, ' ', engagement_str];
    [R_first,slope_first] = dPrime_area_correlationOverTime(twdb,miceIDs,0,engagement,learned);
    [R_reversal,slope_reversal] = dPrime_area_correlationOverTime(twdb,miceIDs,1,engagement,learned);
    
    for m = 1:length(miceIDs)
        figure
        subplot(2,1,1)
        hold on
        plot([R_first{m},R_reversal{m}])
        plot([length(R_first{m}) length(R_first{m})],[nanmin([R_first{m},R_reversal{m}]) nanmax([R_first{m},R_reversal{m}])],'k','LineWidth',3)
        ylabel('R')
        title('Rolling Window')
        hold off
        subplot(2,1,2)
        hold on
        plot([slope_first{m},slope_reversal{m}])
        plot([length(slope_first{m}) length(slope_first{m})],[nanmin([slope_first{m},slope_reversal{m}]) nanmax([slope_first{m},slope_reversal{m}])],'k','LineWidth',3)
        ylabel('Slope')
        hold off
        supertitle({title_str,miceIDs{m},'',''})
    end
    
end