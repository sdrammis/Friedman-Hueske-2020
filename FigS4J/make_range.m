function [ ranges ] = make_range( range, k )
%MAKE_RANGE Split a range into k equal-length ranges. 
%   If the range is not evenly divisible by k, sub-ranges will not all be 
%   of equal length-some will be 1 element longer than the rest, starting 
%   with the sub-ranges at the lower end of the range. 
%   
%   For example, make_range(8, 3) will split the range [1 8] into
%       [1 2 3]
%       [4 5 6]
%       [7 8]
%
%   Note that the length-3 subranges start at the lo end of the range.
%   
%   Input  :: range  - length-2 vector of format [lo hi], where lo and hi
%                      are the bottom and top of the range to split (both inclusive)
%                        
%                        OR
%  
%                      a number specifying top of the range (inclusive). In
%                      this case, the bottom of the range is defaulted to 1
%                      (inclusive).
%             k      - number of sub-ranges to split range into (NOTE: NOT 
%                      length of sub-range, rather how many of them).
%
%   Output :: ranges - (k x 1) cell array,  where the ith cell contains the
%                      the ith sub-range.

ranges = cell(k, 1);

if length(range) == 1
    range = [1 range];
end

lo = range(1) - 1;
hi = range(2);
n = hi - lo;
base = floor(n / k);
leftover = n - (k * base);

prev = 0;
for i = 1:k
   temp = base;
   
   if i <= leftover
       temp = temp + 1;
   end
   
   start = prev + 1;
   finish = start + temp - 1;
   
   ranges{i} = (start:finish) + lo;
   
   prev = finish;
end

end

