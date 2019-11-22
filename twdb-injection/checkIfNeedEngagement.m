function checkIfNeedEngagement(twdb,reversal,year,month,day)

needEngagement = [];
miceIDs = unique({twdb.mouseID});
for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
    sessionIdx = get_mouse_sessions(twdb,mouseID,~reversal,0,'all',0);
    rightYear = [twdb(sessionIdx).sessionYear] >= year;
    rightMonth = [twdb(sessionIdx).sessionMonth] >= month;
    rightDay = [twdb(sessionIdx).sessionDay] > day;
    
    if sum((rightYear + rightMonth + rightDay) == 3) 
        needEngagement = [needEngagement mouseID];
    end
    
end

