function img = create_color_img(n,m,r,g,b)
redChannel = r * ones(n, m, 'uint8');
greenChannel = g * ones(n, m, 'uint8');
blueChannel = b * ones(n, m, 'uint8');
img = cat(3, redChannel, greenChannel, blueChannel);
end

