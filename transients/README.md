# Spike Identification and Grading

0. Update `config.m` to use desired folders.
1. Run `extraction.run` to find potential spikes.
2. Run `classification.run` to grade spikes.
3. Run `dbinj` to add spike information to the twdb.


## Combining mouse data into indivudual files

For ease of analysis, you can run the `savemice` script. This will create a 
matrix of spikes for every mice. Each matrix will be saved as a separate file
which can be loaded later for analysis and plotting.

This function filters out any bad spikes (< 0.55).