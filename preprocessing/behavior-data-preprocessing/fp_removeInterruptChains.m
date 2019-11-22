function tInterrupt_sec = fp_removeInterruptChains(timeBetweenInterrupts_sec,tInterrupt_sec)

dt_Interrupt = diff(tInterrupt_sec);
iMissalignedInterrupts = dt_Interrupt < (timeBetweenInterrupts_sec - 0.5);
iChainEnd = diff(iMissalignedInterrupts)==-1;
iMissalignedInterrupts(iChainEnd) = 0;
tInterrupt_sec([false; iMissalignedInterrupts]) = [];

dt_Interrupt = diff(tInterrupt_sec);
iSmallInterrupts = dt_Interrupt < 1;
for i = find(iSmallInterrupts)'
    if i~=1 && dt_Interrupt(i-1) < (timeBetweenInterrupts_sec-0.03)
        iSmallInterrupts(i-1) = true;
        if ~(dt_Interrupt(i+1) < (timeBetweenInterrupts_sec-0.05))
            iSmallInterrupts(i) = false;
        end
    end
end
tInterrupt_sec([false; iSmallInterrupts]) = [];
