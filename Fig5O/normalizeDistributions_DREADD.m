function normalizedDistributions = normalizeDistributions_DREADD(previousDistributions,sessionDistributions,normalizationType)

distributionTypes = sessionDistributions.Properties.VariableNames;
normalizedDistributions = table;
for d = 1:length(distributionTypes)
    distributionType = distributionTypes{d};
    toNormalize = sessionDistributions.(distributionType);
    baseline = previousDistributions.(distributionType);
    if isequal(normalizationType,'all')
        normalized = toNormalize-nanmean(baseline);
    elseif isequal(normalizationType,'minMax')
        normalized = (toNormalize-min(baseline))/(max(baseline)-min(baseline));
    end
    normalizedDistributions.(distributionType) = normalized;
end