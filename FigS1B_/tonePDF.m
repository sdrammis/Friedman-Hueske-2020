function [vals,licks] = tonePDF(licks,min_lick,max_lick)
%Returns the PDF of number of licks (where index is number of licks)
% if isequal(calc_type,'STA')
%     licks = licks(licks~=0);
%     bins = 1:max_lick;
% elseif isequal(calc_type,'SD')
%     bins = 0:max_lick;
% end

bins = min_lick:max_lick;


licks = licks(logical(sum(licks == min_lick:max(licks),2)));


%Probability Values for amount of licks
vals = zeros(1,length(bins));
for n = 1:length(bins)
    vals(n) = sum(licks == bins(n))/length(licks);
end