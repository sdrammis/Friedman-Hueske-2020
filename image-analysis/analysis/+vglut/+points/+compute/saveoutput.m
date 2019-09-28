function saveoutput(micedb, slicename, s, u, t)
OUT_DIR = '/annex4/afried/resultfiles/analysis_output/vglut_kian/output';

% Get mouse info.
mouseID = vglut.points.compute.find_mouseID(slicename);
if isempty(mouseID)
    return;
end

mouse = micedb(strcmp({micedb.ID}, mouseID));
health = mouse.Health;
firstSessionAge = mouse.firstSessionAge;
if isempty(firstSessionAge)
    firstSessionAge = nan;
end
birthDate = datetime(mouse.birthDate, 'InputFormat', 'yyyy-MM-dd');
perfDate = datetime(mouse.perfusionDate, 'Inputformat', 'yy/MM/dd');
perfusionAge = calmonths(caldiff([birthDate, perfDate], 'months'));
if isempty(perfusionAge)
    perfusionAge = nan;
end
learnedFirstTask = mouse.learnedFirstTask > 0;
if isempty(learnedFirstTask)
    learnedFirstTask = -1;
end
learnedReversalTask = mouse.learnedReversalTask > 0;
if isempty(learnedReversalTask)
    learnedReversalTask = -1;
end

% Save s data to own csv file.
n_s = length(s.areas);
s.maxintensities = s.maxintensities';
s.areas = s.areas';
s.group = s.group';
s.meanIntensity = s.meanIntensity';
s.totalIntensity = s.totalIntensity';
s.medianIntensity = s.medianIntensity';
s.areaStrio = ones(n_s,1) * s.areaStrio;
s.areaMatrix = ones(n_s,1) * s.areaMatrix;
s.health = cell(n_s,1);
s.health(:) = {health};
s.firstSessionAge = ones(n_s,1) * firstSessionAge;
s.perfusionAge = ones(n_s,1) * perfusionAge;
s.learnedFirstTask = ones(n_s,1) * learnedFirstTask;
s.learnedReversalTask = ones(n_s,1) * learnedReversalTask;

sname = [OUT_DIR '/s/' slicename '.csv'];
writetable(struct2table(s), sname);

% Append t data to t file.
fn = fieldnames(t);
for k=1:numel(fn)
    fileID_t = fopen([OUT_DIR '/t/' fn{k} '.csv'], 'a');
    fprintf(fileID_t, '%s, %s, %s, %d, %d, %d, %d, %s \n', ...
                slicename, mouseID, health, firstSessionAge, ...
                perfusionAge, learnedFirstTask, learnedReversalTask, ...
                regexprep(num2str(t.(fn{k})),'\s+',','));
    fclose(fileID_t);
end

% Append u data to u file.
fileID_u = fopen([OUT_DIR '/vglutpoints-u.csv'], 'a');
fn_u = fieldnames(u);
str = '';
for k=1:numel(fn_u)
    dat = u.(fn_u{k});
    if length(dat) == 1
        str_new = num2str(dat);
    else
        str_new = regexprep(num2str(cell2mat(u.(fn_u{k}))),'\s+',',');
    end
    
    if isempty(str)
        str = str_new;
    else
       str = [str ',' str_new]; 
    end
end
str = [slicename ',' mouseID ',' health ',' num2str(firstSessionAge) ...
    ',' num2str(perfusionAge) ',' num2str(learnedFirstTask) ...
    ',' num2str(learnedReversalTask) ',' str '\n'];
fprintf(fileID_t, str);
fclose(fileID_u);
end
