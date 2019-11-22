function miceType = twdb_getMiceAge(twdb,miceType)

miceIDs = get_mouse_ids(twdb,0,'all','all','all','all','all','all',{});
for m = 1:length(miceIDs)
    mouseID = miceIDs{m};
    miceType_idx = first(twdb_lookup(miceType,'index','key','ID',mouseID));
    mouse_birthdate = miceType(miceType_idx).birthDate;
    mouse_firstSessionType = miceType(miceType_idx).firstSessionType;
    firstSessionDate = first(twdb_lookup(twdb,'sessionDate','key','mouseID',mouseID,...
        'key','sessionNumber',1,'key','taskType',mouse_firstSessionType));
    firstSessionAge = months(mouse_birthdate,firstSessionDate);
    miceType(miceType_idx).firstSessionAge = firstSessionAge;
end