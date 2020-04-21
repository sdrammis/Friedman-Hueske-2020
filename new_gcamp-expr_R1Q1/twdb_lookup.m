function [sessions,idxs] = twdb_lookup(dbfile,field,varargin)
% Given a twdb file <dbfile> returns all neurons satisfying the conditions
% in varargin. If the search field is a key lookup, input "key" then the
% appropriate key/field. If the search is a grade threshold search, input
% "grade" then th appropriate field/threshold.
% EXAMPLE: indexes of sessions from month july to august where animal has HD health:
% twdb_lookup('twdbFile.mat','index','grade','sessionMonth',7,8,'key','Health','HD')

if ~isequal(class(dbfile),'struct')
    twdb = load(dbfile);
    twdb = twdb.twdb;
else
    twdb = dbfile;
end

len = length(varargin);
sessions = [twdb.index];
a = 1;
if len ~= 0
    while a < len
        if isequal(varargin{a},'key')
            nComp = twdb_keylookup(twdb, 'index', varargin{a+1}, varargin{a+2});
            a = a+3;
        elseif isequal(varargin{a},'grade')
            nComp = twdb_thresholdlookup(twdb, 'index', varargin{a+1}, varargin{a+2}, varargin{a+3});
            a = a+4;
        else
            error('Must have key or grade identifier.');
        end
        sessions = intersect(sessions, cell2mat(nComp));
    end
end
idxs = [];
for n = 1:length(sessions)
    nIndex = find([twdb.index]==sessions(n));
    idxs(n) = nIndex(1);
end
ns = {twdb.(field)};
sessions = ns(idxs);
