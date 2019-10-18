% Author: QZ
% 07/10/2019
function mouseData = getMouseData_QZ(twdb,msID)
% get all data for one mouse from twdb at session level
% msID :: cell or string of single mouse ID
% mouseData :: table of data for the mouse
rows = twdb_lookup(twdb,'index','key','mouseID',msID);
mouseData = struct2table(twdb(cell2mat(rows)));
end