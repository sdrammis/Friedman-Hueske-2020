% We are only considering the bottom middle region (where the fiber
% records).

% [mixed, not mixed, unclear]
e11Dlx1D1 = [0 0 0];
e11Dlx1D2 = [0 0 0];
e11Mash1D1 = [0 0 0];
e11Mash1D2 = [0 0 0];
e11Dlx1D1Mice = {'2447', '5233', '3348', '4229'};
e11Dlx1D2Mice = {'3337', '3343', '3084', '3085'};
e11Mash1D1Mice = {'3552', '3545', '3535', '3536'};
e11Mash1D2Mice = {'3128', '3131', '3130', '3562'};

e15Dlx1D1 = [0 0 0];
e15Dlx1D2 = [0 0 0];
e15Mash1D1 = [0 0 0];
e15Mash1D2 = [0 0 0];
e15Dlx1D1Mice = {'3514', '3516', '3512', '4186'};
e15Dlx1D2Mice = {'3816', '3518', '3517', '3953'};
e15Mash1D1Mice = {'3556', '3899', '3846'};
e15Mash1D2Mice = {'3568', '3570', '3567', '3903'};

for i=2:height(T)
    mixed = first(T.overlap(i));
    notMixed = first(T.noOverlap(i));
    unsure = first(T.unsureOverlap(i));
    counts = [mixed notMixed unsure];
    
    mouseID = num2str(T.mouseID(i));
    if any(strcmp(mouseID, e11Dlx1D1Mice))
        e11Dlx1D1 = e11Dlx1D1 + counts;
    elseif any(strcmp(mouseID, e11Dlx1D2Mice))
        e11Dlx1D2 = e11Dlx1D2 + counts;       
    elseif any(strcmp(mouseID, e11Mash1D1Mice))
        e11Mash1D1 = e11Mash1D1 + counts;
    elseif any(strcmp(mouseID, e11Mash1D2Mice))
        e11Mash1D2 = e11Mash1D2 + counts;
    elseif any(strcmp(mouseID, e15Dlx1D1Mice))
        e15Dlx1D1 = e15Dlx1D1 + counts;
    elseif any(strcmp(mouseID, e15Dlx1D2Mice))
        e15Dlx1D2 = e15Dlx1D2 + counts;
    elseif any(strcmp(mouseID, e15Mash1D1Mice))
        e15Mash1D1 = e15Mash1D1 + counts;
    elseif any(strcmp(mouseID, e15Mash1D2Mice))
        e15Mash1D2 = e15Mash1D2 + counts;
    end
end

l = {'Mixed', 'Not Mixed', 'Uncertain'};

f11 = figure; 
subplot(2, 2, 1);
pie_modified(e11Dlx1D1, l);
title('e11Dlx1D1');
subplot(2, 2, 2);
pie_modified(e11Dlx1D2, l);
title('e11Dlx1D2');
subplot(2, 2, 3);
pie_modified(e11Mash1D1, l);
title('e11Mash1D1');
subplot(2, 2, 4);
pie_modified(e11Mash1D2, l);
title('e11Mash1D2');

f15 = figure; 
subplot(2, 2, 1);
pie_modified(e15Dlx1D1, l);
title('e15Dlx1D1');
subplot(2, 2, 2);
pie_modified(e15Dlx1D2, l);
title('e15Dlx1D2');
subplot(2, 2, 3);
pie_modified(e15Mash1D1, l);
title('e15Mash1D1');
subplot(2, 2, 4);
pie_modified(e15Mash1D2, l);
title('e15Mash1D2');

function pie_modified(dat,l)
if sum(dat) == 0 
    return;
end
pie(dat, l);
end
