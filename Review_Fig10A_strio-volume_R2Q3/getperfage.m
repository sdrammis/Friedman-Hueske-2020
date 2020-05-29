function age = getperfage(mouse)
birthDate = datetime(mouse.birthDate, 'InputFormat', 'yyyy-MM-dd');
perfDate = datetime(mouse.perfusionDate, 'Inputformat', 'yyyy-MM-dd');
age = calmonths(caldiff([birthDate, perfDate], 'months'));
end

