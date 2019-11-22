function tInterrupt_sec = fp_addMissingInterrupts(timeBetweenInterrupts_sec,tInterrupt_sec)


dt_Interrupt = diff(tInterrupt_sec);
iMissingInterrupts=find(dt_Interrupt > (timeBetweenInterrupts_sec + 0.1));
for n = 1:length(iMissingInterrupts)
    iInt = iMissingInterrupts(n);
    nMissing = (tInterrupt_sec(iInt+1)-tInterrupt_sec(iInt))/timeBetweenInterrupts_sec - 1;
    if nMissing/round(nMissing) < 1.005 && nMissing/round(nMissing) > 0.995
        nMissing = round(nMissing);
        timeBetweenMissing = (tInterrupt_sec(iInt+1)-tInterrupt_sec(iInt))/(nMissing+1);
        addedInterrupts = tInterrupt_sec(iInt) + (1:nMissing)'*timeBetweenMissing;
        tInterrupt_sec = [tInterrupt_sec(1:iInt); addedInterrupts; tInterrupt_sec(iInt+1:end)];
        iMissingInterrupts = iMissingInterrupts + nMissing;
    end
end