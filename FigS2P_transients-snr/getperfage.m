function age = getperfage(mouse)
birthDate = datetime(mouse.birthDate, 'InputFormat', 'yyyy-MM-dd');
try
    perfDate = datetime(mouse.perfusionDate, 'Inputformat', 'yy/MM/dd');
catch
    perfDate = datetime(mouse.perfusionDate, 'Inputformat', 'yyyy-MM-dd');
end
age = calmonths(caldiff([birthDate, perfDate], 'months'));
end
