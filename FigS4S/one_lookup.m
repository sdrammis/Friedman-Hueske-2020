function [ result_set ] = one_lookup(db, key, operator, value_to_compare)
%ONE_LOOKUP Apply one Key Clause of LOOKUP function
%
%   INPUT    :: db               - database (a 1 x N struct)
%               key              - Field Name component of Key Clause
%               operator         - Relationship component of Key Clause
%               value_to_compare - Value component of Key Clause
%
%   OUTPUT   :: result_set       - 1 x K struct (another DB) consisting of
%                                   entries queried according Key Clause

result_set = [];

% Iterate over every entry of DB. Keep entries that satisfy the given
% condition.

for entry = db
    % Check for existence of key
    if ~isfield(db, key)
        error('twdb_lookup:nsfield',...
            'Field %s does not exist.', key)
    end

    value = entry.(key);
    
    % To solve fields with "blank"; ideally change to NaN
    if isempty(value)
        continue
    end
    
    switch class(value)
        case {'double', 'single', ...
                'int8', 'int16', 'int32', 'int64', ...
                'uint8', 'uint16', 'uint32', 'uint64'}
            
            value_type = 'number';
        case {'string', 'char'}
            value_type = 'string';
            
        otherwise
            value_type = class(value);
    end
    
    switch value_type
        case 'number'
            sat = sat_double(value, operator, value_to_compare);
        case 'string'
            sat = sat_str(value, operator, value_to_compare);
        otherwise
            error('Cannot compare objects of type of %s', upper(value_type));
    end

    if sat
        result_set = [result_set entry];
    end
end

