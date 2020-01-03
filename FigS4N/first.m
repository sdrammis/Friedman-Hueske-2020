function ret = first(cellArr)
if isempty(cellArr)
    ret = [];
else
    ret = cellArr{1};
end
