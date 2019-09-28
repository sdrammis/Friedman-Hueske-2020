function data = get_mice_data(T, mice)
n = length(mice);
data = cell(1,n);
for i=1:n
    mouse = mice(i);
    mouseT = T(T.mouseID == str2double(mouse.ID),:);
    data{i} = mouseT.numBlobs ./ mouseT.cellAreaPixels;
end
end
