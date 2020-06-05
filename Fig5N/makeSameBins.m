function finalEdges = makeSameBins(dist1,dist2,numBins)

    roundTo = 4;
    [~,dist1_edges] = histcounts(dist1,numBins); 
    dist1_edges = round(dist1_edges,roundTo);
    bin_size = round(dist1_edges(2)-dist1_edges(1),roundTo);
    min_dist2 = min(dist2);
    max_dist2 = max(dist2); 
    dist2_Edges = dist1_edges;    
    if min_dist2<dist1_edges(1)
        dist2_Edges = round(fliplr(dist1_edges(end):-bin_size:(min_dist2-bin_size)),roundTo);
    end    
    if max_dist2>dist1_edges(end)
        dist2_Edges = round(dist2_Edges(1):bin_size:(max_dist2+bin_size),roundTo);
    end

    finalEdges = dist2_Edges;