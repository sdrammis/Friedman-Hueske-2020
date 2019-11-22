function twdb = injectMiceType(twdb,miceType)

miceType = load(miceType);
miceType = miceType.miceType;
miceTypeIDs = {miceType(:).ID}; %Mice IDs (name or number of mice)

for idx=1:length(twdb)
    mouseID = twdb(idx).mouseID;
    miceTypeID = find(ismember(miceTypeIDs, mouseID));
    if ~isempty(miceTypeID)
        twdb(idx).Health = miceType(miceTypeID).Health;
        twdb(idx).intendedStriosomality = miceType(miceTypeID).intendedStriosomality;
        twdb(idx).birthDate = miceType(miceTypeID).birthDate;
        twdb(idx).perfusionDate = miceType(miceTypeID).perfusionDate;
        twdb(idx).DREADDType = miceType(miceTypeID).DREADDType;
        twdb(idx).genotype = miceType(miceTypeID).genotype;
        twdb(idx).positive = miceType(miceTypeID).positive;
        twdb(idx).histologyStriosomality = miceType(miceTypeID).histologyStriosomality;
        twdb(idx).firstSessionType = miceType(miceTypeID).firstSessionType;
        twdb(idx).firstSessionAge = miceType(miceTypeID).firstSessionAge;
        twdb(idx).learnedFirstTask = miceType(miceTypeID).learnedFirstTask;
        twdb(idx).learnedReversalTask = miceType(miceTypeID).learnedReversalTask;
    end
end