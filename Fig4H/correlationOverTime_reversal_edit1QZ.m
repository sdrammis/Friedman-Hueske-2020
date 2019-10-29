function [R_first,R_reversal] = correlationOverTime_reversal_edit1QZ(miceIDs,title_str,engagement,...
    rTones,cTones,miceTrials1,miceTrials2,miceFluorTrials1,miceFluorTrials2,percentage,factor)
    [R_first,~] = dPrime_area_correlationOverTime_edit1QZ(miceIDs,...
        miceTrials1,miceFluorTrials1,rTones,cTones,engagement,percentage,factor);
    [R_reversal,~] = dPrime_area_correlationOverTime_edit1QZ(miceIDs,...
        miceTrials2,miceFluorTrials2,rTones,cTones,engagement,percentage,factor);
    disp(size(R_first));
    disp(size(R_reversal));
    for m = 1:length(miceIDs)
        figure()
        hold on
        plot([R_first{m},R_reversal{m}])
        plot([length(R_first{m}) length(R_first{m})],[nanmin([R_first{m},R_reversal{m}]) nanmax([R_first{m},R_reversal{m}])],'k','LineWidth',3)
        ylabel('R')
        title({[title_str ' ' miceIDs{m}],'Rolling Window'})
        hold off
    end

end