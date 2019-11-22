function [vals,licks] = tonePDF(licks,min_lick,max_lick)
%Returns the PDF of number of licks (where index is number of licks)

bins = min_lick:max_lick;


licks = licks(logical(sum(licks == min_lick:max(licks),2)));


%Probability Values for amount of licks
vals = zeros(1,length(bins));
for n = 1:length(bins)
    vals(n) = sum(licks == bins(n))/length(licks);
end