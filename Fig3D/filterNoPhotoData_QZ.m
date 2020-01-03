% Author: QZ
% 07/11/2019
function indices = filterNoPhotoData_QZ(twdb,idxs)
% indices :: indices to be removed
indices = [];
for i = 1:length(idxs)
    if isempty(twdb(idxs(i)).raw470Session)
        indices = [indices i];
    end
end
end