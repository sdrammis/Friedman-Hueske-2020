function tInterrupt_sec = fp_realignInterrupts(tInterrupt_sec)

    dt_Interrupt = diff(tInterrupt_sec);
    timeBetweenInterrupts_sec = median(dt_Interrupt);
    greaterInterrupts = dt_Interrupt > (timeBetweenInterrupts_sec + 0.01);
    smallerInterrupts = dt_Interrupt < (timeBetweenInterrupts_sec - 0.01);

    iMissalignedInterrupts = greaterInterrupts + smallerInterrupts;
    iMissalignedRuns = find([false; diff(iMissalignedInterrupts)~=0]);

    if ~isempty(iMissalignedRuns)
        if iMissalignedRuns(1) == 2
            iMissalignedRuns(1) = [];
        end
        if iMissalignedInterrupts(1) == 1 && iMissalignedInterrupts(2) ~= 0
            iMissalignedRuns = [1; iMissalignedRuns];
        end
    end

    for i = 1:2:length(iMissalignedRuns)-1
        missalignedRun = dt_Interrupt(iMissalignedRuns(i):iMissalignedRuns(i+1)-1);
        nMissaligned = round(sum(missalignedRun)/timeBetweenInterrupts_sec)-1;
        iRemoveMissaligned = iMissalignedRuns(i)+1:iMissalignedRuns(i+1)-1;
        tInterrupt_sec(iRemoveMissaligned) = [];
        tInterrupt_sec = fp_addMissingInterrupts(timeBetweenInterrupts_sec,tInterrupt_sec);
        iMissalignedRuns = iMissalignedRuns + nMissaligned - length(iRemoveMissaligned);
        dt_Interrupt = diff(tInterrupt_sec);

    end
end