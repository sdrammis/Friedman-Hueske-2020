function [ sat ] = sat_str( value, operator, value_to_compare )
%SAT_STR Compare two strings lexicographically
%   
% Input :: value            - left operand
%          operator         - operator; can be any of:
%                               '=', '!=', '>', '<', '>=', '<=', '...', '..<'
%          value_to_compare - right operand; if operator is '...' or '..<',
%                               must be a length-2 cell array, where {1} is
%                               bottom of range, {2} is top of range
%
% Output :: sat - true if value (operator) value_to_compare, false otherwise

if ~iscell(value_to_compare)
    cmp = cstrcmp(char(value), char(value_to_compare));
else
    if cstrcmp(value_to_compare{1}, value_to_compare{2}) > 0
        error('Invalid range. Second range value must be greater than first. %s is not greater than %s',...
        value_to_compare{:})
    end

    cmp1 = cstrcmp(char(value), char(value_to_compare{1}));
    cmp2 = cstrcmp(char(value), char(value_to_compare{2}));
end

switch operator
    case '='
        sat = cmp == 0;
    case '!='
        sat = cmp ~= 0;
    case '>'
        sat = cmp == 1;
    case '<'
        sat = cmp == -1;
    case '>='
        sat = cmp >= 0;
    case '<='
        sat = cmp <= 0;
    case '...'
        sat = cmp1 >= 0 & cmp2 <= 0;
    case '..<'        
        sat = cmp1 >= 0 & cmp2 < 0;
end

end

