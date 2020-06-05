function val = fitnessfun(x, F)
ENG = 1;
[t1, t2] = runnet(x,ENG);
val = F(t1, t2);
end
