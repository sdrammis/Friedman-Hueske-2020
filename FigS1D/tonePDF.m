function [vals,licks] = tonePDF(licks,max_lick)
%Returns the PDF of number of licks (where index is number of licks)

bins = 0:max_lick;

%Probability Values for amount of licks
vals = zeros(1,length(bins));
for n = 1:length(bins)
    vals(n) = sum(licks == bins(n))/length(licks);
end