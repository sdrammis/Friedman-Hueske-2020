 function ttest2_QZ(d1,d2,dispStr)
% see documentation for ttest2_QZ. Similar, but for paired t test
d1 = d1(isfinite(d1));
d2 = d2(isfinite(d2));
if isempty(d1) || isempty(d2)
    if ~isempty(d1)
        [h,p] = ttest2(d1);
        disp([dispStr,'Significance: ',num2str(h),', p-val: ',num2str(p)]);
    elseif ~isempty(d2)
        [h,p] = ttest2(d2);
        disp([dispStr,'Significance: ',num2str(h),', p-val: ',num2str(p)]);
    else
        disp([dispStr,'Not enough information.']);
    end
else
    [h,p] = ttest2(d1,d2);
    disp([dispStr,'Significance: ',num2str(h),', p-val: ',num2str(p)]);
end
end