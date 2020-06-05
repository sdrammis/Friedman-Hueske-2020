% Author: QZ
% 06/12/2019
function anova1_QZ(yArrays,dispStr)
% yArrays  cell array of arrays, each array corresponding to a group
% dispStr  string to be displayed
y = [];
for i = 1:length(yArrays)
    array = yArrays{i};
    array = array(isfinite(array));
    % after this, hopefully the data are still the same length
    y = [y;array];
end
p = anova1(y);
disp([dispStr,'p-val: ',num2str(p)]);
end