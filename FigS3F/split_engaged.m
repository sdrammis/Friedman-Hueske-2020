function [newEngaged,newNotEngaged] = split_engaged(engaged,notEngaged, changepts)

 for i = 1:length(engaged)
        if istable(engaged{i}) && istable(notEngaged{i})
            notEngaged{i}.NewEngagement = zeros(height(notEngaged{i}), 1);
            engaged{i}.NewEngagement = ones(height(engaged{i}), 1);
        elseif ~istable(engaged{i}) && istable(notEngaged{i})
            notEngaged{i}.NewEngagement = zeros(height(notEngaged{i}), 1);
            names = notEngaged{i}.Properties.VariableNames;
            engaged{i} = cell2table(cell(0,21), 'VariableNames', names);
        elseif istable(engaged{i}) && ~istable(notEngaged{i})
            engaged{i}.NewEngagement = ones(height(engaged{i}), 1);
            names = engaged{i}.Properties.VariableNames;
            notEngaged{i} = cell2table(cell(0,21), 'VariableNames', names);
        end
        
    end
  
trials = [];
for i = 1:length(engaged) 
    trials = [trials; engaged{i}; notEngaged{i}];    
end

trials = sortrows(sortrows(trials, 'IDXofTrial'), 'SessionNumber');

if length(changepts) == 1
    split_trials = cell(1,2);
    newEngaged = cell(1,2);
    newNotEngaged = cell(1,2);
    for i = 1:height(trials)
        if i <= changepts(1)
            split_trials{1} = [split_trials{1}; trials(i,:)];
        end
        if i > changepts(1) 
            split_trials{2}  = [split_trials{2}; trials(i,:)];
        end
    
    end
end


if length(changepts) == 2
    split_trials = cell(1,3);
    newEngaged = cell(1,3);
    newNotEngaged = cell(1,3);
    for i = 1:height(trials)
        if i <= changepts(1)
            split_trials{1} = [split_trials{1}; trials(i,:)];
        end
        if i > changepts(1) && i <= changepts(2)
            split_trials{2}  = [split_trials{2}; trials(i,:)];
        end
        if i > changepts(2)
            split_trials{3}  = [split_trials{3}; trials(i,:)];
        end
        
    end
end

if length(changepts) == 3
    split_trials = cell(1,4);
    newEngaged = cell(1,4);
    newNotEngaged = cell(1,4);
    for i = 1:height(trials)
        if i <= changepts(1)
            split_trials{1} = [split_trials{1}; trials(i,:)];
        end
        if i > changepts(1) && i <= changepts(2)
            split_trials{2}  = [split_trials{2}; trials(i,:)];
        end
        if i > changepts(2) && i <= changepts(3)
            split_trials{3}  = [split_trials{3}; trials(i,:)];
        end
        if i > changepts(3)
            split_trials{4}  = [split_trials{4}; trials(i,:)];
        end
        
    end
end

if length(changepts) == 4
    split_trials = cell(1,5);
    newEngaged = cell(1,5);
    newNotEngaged = cell(1,5);
    for i = 1:height(trials)
        if i <= changepts(1)
            split_trials{1} = [split_trials{1}; trials(i,:)];
        end
        if i > changepts(1) && i <= changepts(2)
            split_trials{2}  = [split_trials{2}; trials(i,:)];
        end
        if i > changepts(2) && i <= changepts(3)
            split_trials{3}  = [split_trials{3}; trials(i,:)];
        end
        if i > changepts(3) && i <= changepts(4)
            split_trials{4}  = [split_trials{4}; trials(i,:)];
        end
        if i > changepts(4)
            split_trials{5}  = [split_trials{5}; trials(i,:)];
        end
        
    end
end

for i = 1:length(changepts)+1
    if isempty(split_trials{i})
        continue
    else
        newEngaged{i} = split_trials{i}(split_trials{i}.NewEngagement == 1,:);
        newNotEngaged{i} = split_trials{i}(split_trials{i}.NewEngagement == 0,:);
    end
end





