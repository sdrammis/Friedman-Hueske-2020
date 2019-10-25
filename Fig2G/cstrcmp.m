function cmp = cstrcmp( a, b )
%CSTRCMP Compare two strings lexicographically
%   
% Input  :: a - left operand
%           b - right operand
% Output :: 0 if a == b, -1 if a < b, 1 if a > b

    % Force the strings to equal length
    x = char({a;b});
    % Subtract one from the other
    d = x(1,:) - x(2,:);
    % Remove zero entries
    d(~d) = [];
    if isempty(d)
        cmp = 0;
    else
        cmp = d(1);
    end
    
    cmp = sign(cmp);
end