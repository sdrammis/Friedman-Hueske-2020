function clegend(cs, labels, lcn)
n = length(cs);

h = zeros(n, 1);
for i=1:n
   h(i) = plot(nan, nan, 'Color', cs{i}); 
end
legend(h, labels, 'Location', lcn);
end

