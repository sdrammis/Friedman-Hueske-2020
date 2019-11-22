function fp_removeBadFibers(dataFile)
load(dataFile)

fixedFiberBoxTable = fiberBoxTable;
for n = 1:size(blue_imageStackValues,2)
    if n > size(beh_filename)
        continue
    end
    if isequal(beh_filename{n},'fiber-box-table.txt')
        beh_filename(n) = [];
    elseif fiberBoxTable(n,1) ~= n
        fiberN = fiberBoxTable(n,1);
        fixedFiberBoxTable(n,:) = [n fiberBoxTable(n,2)];
        fixed = 1;
    end
end


if exist('fixed')
    purple_imageStackValues = purple_imageStackValues(:,fiberBoxTable(:,1));
    blue_imageStackValues = blue_imageStackValues(:,fiberBoxTable(:,1));
    fiberBoxTable = fixedFiberBoxTable;
    save(dataFile,'purple_imageStackValues','blue_imageStackValues',...
               'purple_imageStackTimestamps','blue_imageStackTimestamps',...
               'beh_filename','beh_data','fiberBoxTable');
end

if size(fiberBoxTable,1) ~= size(blue_imageStackValues,2) || size(fiberBoxTable,1) ~= size(purple_imageStackValues,2)
    fixed
end