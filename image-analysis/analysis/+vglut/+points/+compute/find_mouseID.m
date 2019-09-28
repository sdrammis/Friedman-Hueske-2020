function mouseID = find_mouseID(slicename)
slicename = lower(slicename);
matchRegion = regexp(slicename, 'region [0-9]+', 'match');
if isempty(matchRegion)
    matchMouse = regexp(slicename, '-[0-9]+_(slice|region)', 'match');
    splits = split(matchMouse{1}, '_');
    mouseID = splits{1}(2:end);
else
    mouseID = [];
end
end

