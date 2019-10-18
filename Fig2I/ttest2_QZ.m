function ttest2_QZ(d1,d2,dispStr)
% param1  d1  array of numbers of one group's data
% param2  d2  array of numbers of other group's data
% param3  dispStr  string indicating what you ran the test on, tb disped
% got rid of returns because didn't need them for now!
% return1  h  result of the hypothesis (sig. or not). Boolean.
% return2  p  p-value
d1 = d1(isfinite(d1));
d2 = d2(isfinite(d2));
if isempty(d1) || isempty(d2)
    disp([dispStr,'Not enough information.']);
else
    [h,p] = ttest2(d1,d2);
    disp([dispStr,'Significance: ',num2str(h),', p-val: ',num2str(p)]);
end
end