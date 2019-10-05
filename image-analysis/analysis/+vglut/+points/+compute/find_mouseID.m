function mouseIDKian = find_mouseID(slicename)
M = pvmsnconn.buildregionsmap(); % Maps slice region numbers to mouse IDs

slicename = lower(slicename);
matchRegion = regexp(slicename, 'region [0-9]+', 'match');
if isempty(matchRegion)
    matchMouse = regexp(slicename, '-[0-9]+_slice', 'match');
    matchdate = regexp(slicename, '2018-+[0-9]+[0-9]-[0-9]+[0-9]', 'match');
    matchdate1 = regexp(slicename, '2018+[0-9]+[0-9]+[0-9]+[0-9]', 'match');
    matchdate2 = regexp(slicename, '2019+[0-9]+[0-9]+[0-9]+[0-9]', 'match');
    matchMouse2 = regexp(slicename, '-[0-9]+_region', 'match');
    
    if ~isempty(matchMouse)
        splits = split(matchMouse{1}, '_');
        mouseID = splits{1}(2:end);
    else
        splits = split(matchMouse2{1}, '_');
        mouseID = splits{1}(2:end);
    end
    
    
    
    if ~isempty(matchdate)
        splitsdate = split(matchdate{1}, '-');
        finaldate=strcat(splitsdate{1}, splitsdate{2}, splitsdate{3});
    elseif ~isempty(matchdate1)
        finaldate = matchdate1{1};
    else
        finaldate = matchdate2{1};
    end
    
    mouseIDKian=strcat(finaldate,'_',mouseID);
end

