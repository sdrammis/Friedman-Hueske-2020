function [ result_set ] = key_lookup(db_or_dbfile, varargin)
%KEY_LOOKUP Main helper function of LOOKUP. Applies Key Clauses, Order, and
%Uniqueness clauses
%
%   INPUT    :: db         - database (a 1 x N struct)
%               varargin   - all varargin from LOOKUP, with exception of Fields
%                            clause
%   OUTPUT   :: result_set - 1 x K struct (another DB) consisting of
%                               entries queried according to criterion

% Load DB if given file name
if ~isstruct(db_or_dbfile)
    twdb = load(db_or_dbfile);
    twdb = twdb.twdb;
else
    twdb = db_or_dbfile;
end

order_by_index = find(strcmp(varargin, 'Order'));
unique_index = find(strcmp(varargin, 'Unique'));

if isempty(order_by_index) && isempty(unique_index)
    condition_args = varargin;
    order_args = {};
    unique_args = {};
else
    if isempty(order_by_index)
        condition_args = varargin(1:unique_index - 1);
        order_args = {};
        unique_args = varargin(unique_index + 1:end);
    elseif isempty(unique_index)
        condition_args = varargin(1:order_by_index - 1);
        order_args = varargin(order_by_index + 1:end);
        unique_args = {};
    else
        condition_args = varargin(1:order_by_index - 1);
        order_args = varargin(order_by_index + 1:unique_index - 1);
        unique_args = varargin(unique_index + 1:end);
    end
end

% Check for correct number of variables (multiple of 3, since each
% condition is 3 input vars
if mod(length(condition_args), 3) ~= 0
    error('twdb_lookup:nsfield',...
            'Incorrect format of input')
end


% Extract conditions and place them in cell array
% i.e. conditions = { {'id', '=', 3}, {'name', '!=', 'steve'} }

num_conditions = length(condition_args) / 3;
conditions = cell(1, num_conditions);

for i = (0 : num_conditions-1)
   condition_start = i * 3 + 1;
   condition_end = (i + 1) * 3;
   
   conditions{i + 1} = condition_args(condition_start:condition_end);
end

% Iterate through each condition, keeping only entries that satisfy each
% progressive condition.
result_set = twdb;
for j = (1 : length(conditions))
    condition = conditions{j};
    
    key = condition{1};
    operator = condition{2};
    value_to_compare = condition{3};
    
    result_set = one_lookup(result_set, key, operator, value_to_compare);
end


% Order
if ~isempty(order_args)
    if length(order_args) > 2
        error('Order can only take 2 arguments - the first is the field name, second is "ASC" or "DESC"');
    end

    order_field = order_args{1};

    if length(order_args) == 1
        direction = 1;
    else
        order_type = order_args{2};
        if isequal(order_type, 'ASC')
            direction = 1;
        else
            direction = -1;
        end
    end
    
    if ~isempty(result_set)
        result_set = sortStruct(result_set, order_field, direction);
    end
end


% Unique
if ~isempty(unique_args)
    unique_field = unique_args{1};
    
    unique_result_set = [];
    existing_entries = {};
    i = 1;
    for entry = result_set    
        field = entry.(unique_field);
        
        if ~ischar(field)
            field = num2str(field);
        end
            
        if isempty(find(strcmp(existing_entries, field), 1))
            unique_result_set = [unique_result_set entry];
            existing_entries{i} = field;
            i = i + 1;
        end
    end

    result_set = unique_result_set;
end

