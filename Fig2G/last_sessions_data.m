function [ t_data, f_data, d_data, c_data ] = last_sessions_data(r, mouse_type, threshold)
%LAST_SESSIONS_DATA Summary of this function goes here
%   Detailed explanation goes here

if strcmp(mouse_type, 'WT')
    mice = r.WTMice;
elseif strcmp(mouse_type, 'HD')
    mice = r.HDMice;
end

n_mice = length(mice);

t_data = cell(n_mice, threshold);
f_data = cell(n_mice, threshold);
d_data = cell(n_mice, threshold);
c_data = cell(n_mice, threshold);

for i = 1:n_mice
    mouseID = mice{i};
    mouse_sessions = lookup(r.Sessions, 'mouseID', '=', mouseID, 'Order', 'sessionNumber', 'ASC')

    num_sessions = length(mouse_sessions)

    for j = 1:threshold
        session = mouse_sessions(end + 1 - j);
        [t, f, d, c] = ROC.roc_analysis_sessions(session);

        t_data{i, j} = t;
        f_data{i, j} = f;
        d_data{i, j} = d;
        c_data{i, j} = c;
    end
end

t_data = cell2mat(t_data);
f_data = cell2mat(f_data);
d_data = cell2mat(d_data);
c_data = cell2mat(c_data);

t_data = num2cell(t_data, 2)';
f_data = num2cell(f_data, 2)';
d_data = mean(d_data, 2);
c_data = mean(c_data, 2);

end
