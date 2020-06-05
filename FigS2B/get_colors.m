function [ colors ] = get_colors( n )
%GET_COLORS Get any amount of default colors for use with AVG_ERRORBAR.
%   
%   Input  :: n      - number of colors to get
%   Output :: colors - (n x 1) cell array, where each cell is a length-3
%                      RGB color vector

all_colors = {
    rgb('SALMON');
    rgb('CORNFLOWERBLUE');
    rgb('CORAL');
    rgb('TEAL');
    rgb('GOLD');
    rgb('PURPLE');
    rgb('MAROON');
    rgb('DEEPPINK');
    rgb('TOMATO');
    rgb('SLATEBLUE');
    rgb('LIGHTGREEN');
    rgb('BLACK');
    rgb('SALMON');
    rgb('TURQUOISE');
    rgb('INDIGO');
    rgb('PAPAYAWHIP');
    rgb('CORNSILK');
    rgb('MISTYROSE');
};

colors = all_colors(1:n);

end