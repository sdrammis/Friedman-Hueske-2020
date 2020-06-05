function [mouse_ez1,mouse_nz1,mouse_ez2,mouse_nz2] = correlateEngagementPupilSize_mouse(twdb,mouseID,fieldname)

session_idx = twdb_lookup(twdb,'index','key','mouseID',mouseID);
mouse_ez1 = [];
mouse_nz1 = [];
mouse_ez2 = [];
mouse_nz2 = [];
for n = 1:length(session_idx)
    trialData = twdb(session_idx{n}).trialData;
    [mouse_ez1(n), mouse_nz1(n), mouse_ez2(n), mouse_nz2(n)] = correlateEngagementPupilSize_session(trialData,fieldname);
end

