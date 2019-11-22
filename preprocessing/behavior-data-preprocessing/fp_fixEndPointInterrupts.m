function tInterrupt_sec = fp_fixEndPointInterrupts(tInterrupt_sec)

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
end

% Fix endpoint
if iMissalignedInterrupts(end) == 1
    missalignedRun = dt_Interrupt(iMissalignedRuns(end):end);
    nMissaligned = round(sum(missalignedRun)/timeBetweenInterrupts_sec);
    tInterrupt_sec(iMissalignedRuns(end)+1:end) = [];
    for n = 1:nMissaligned
        tInterrupt_sec = [tInterrupt_sec; tInterrupt_sec(end)+timeBetweenInterrupts_sec];
    end
end

%Fix Interrupts that have missaligned runs but with correctly timed
%interrupts in between. For example: goodInt BigInt goodInt smallInr goodInt
if ~isempty(iMissalignedRuns) && sum(diff(iMissalignedRuns)) == (length(iMissalignedRuns)-1)
    missalignedRun = dt_Interrupt(iMissalignedRuns(1):iMissalignedRuns(end)-1);
    iRemoveMissaligned = iMissalignedRuns(1)+1:iMissalignedRuns(end)-1;
    tInterrupt_sec(iRemoveMissaligned) = [];
    tInterrupt_sec = fp_addMissingInterrupts(timeBetweenInterrupts_sec,tInterrupt_sec);    
end