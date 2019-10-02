function micedb = fromtwdb(micedb, twdb)
% Moves relevent twdb data into the micdb (eg. sucrose deval date).

for i=1:length(micedb)
   mouse = micedb(i);
   
   sucroseDevalDate = getdate(twdb, mouse.ID, 'Sucrose');
   waterDevalDate = getdate(twdb, mouse.ID, 'Water');
   startdate2T = getfirstdate(twdb, mouse.ID, 'taskType', 'tt'); 
   startdate2TR = getfirstdate(twdb, mouse.ID, 'taskType', '2tr'); 
   enddate2T = getlastdate(twdb, mouse.ID, 'taskType', 'tt');
   enddate2TR = getlastdate(twdb, mouse.ID, 'taskType', '2tr');
   isphot = isphotmouse(twdb, mouse.ID);
   
   micedb(i).sucroseDevalDate = sucroseDevalDate;
   micedb(i).waterDevalDate = waterDevalDate;
   micedb(i).startdate2T = startdate2T;
   micedb(i).startdate2TR = startdate2TR;
   micedb(i).enddate2T = enddate2T;
   micedb(i).enddate2TR = enddate2TR;
   micedb(i).isphotometry = isphot;
end
end

function isphot = isphotmouse(twdb, mouseID)
phot = twdb_lookup(twdb, 'raw470Session', 'key', 'mouseID', mouseID);
if isempty(phot)
    isphot = -1;
else
    isphot = ~all(cellfun(@isempty, phot));
end
end

function sdate = getlastdate(twdb, mouseID, key, val)
sessions = twdb_lookup(twdb, 'sessionNumber', ...
       'key', 'mouseID', mouseID, 'key', key, val);
lastsession = max(cell2mat(sessions));
sdate = twdb_lookup(twdb, 'sessionDate', ...
       'key', 'mouseID', mouseID, 'key', 'sessionNumber', lastsession, ...
       'key', key', val);
end

function sdate = getfirstdate(twdb, mouseID, key, val)
sdate = twdb_lookup(twdb, 'sessionDate', ...
       'key', 'mouseID', mouseID, 'key', 'sessionNumber', 1, ...
       'key', key', val);
end

function sdate = getdate(twdb, mouseID, val)
sdate = twdb_lookup(twdb, 'sessionDate', ...
       'key', 'mouseID', mouseID, 'key', 'devaluation', val);
end
