function [x2, n, b] = compute_xpdf(x)
  x2 = reshape(x, 1, prod(size(x)));
  [n, b] = hist(x2, 40);
  % This is definitely not probability density function
  x2 = sort(x2);
end

