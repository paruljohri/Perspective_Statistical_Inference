Here are scripts used to perform analyses in the manuscript entitled "Recommendations for improving statistical Inference in Population Genomics" by Parul Johri, Charles F Aquadro, Mark Beaumont, Brian Charlesworth, Laurent Excoffier, Adam Eyre-Walker, Peter D Keightley, Michael Lynch, Gil McVean, Bret A Payseur, Susanne P Pfeifer, Wolfgang Stephan, and Jeffrey D Jensen.

BioRxiv link : https://www.biorxiv.org/content/10.1101/2021.10.27.466171v1.abstract \
Final publication : https://journals-plos-org.libproxy.lib.unc.edu/plosbiology/article?id=10.1371/journal.pbio.3001669#sec004 \

Here is the general workflow and the associated folders that have relevant scripts:

1. Folder: ABCScriptsNeutralDemography\
   Scripts to perform simulations and calcualte statistics to perform ABC under a neutral model with a single size change are provided here.

2. Folder: ABCScriptsPosSel\
   Scripts to perform simulations and calcualte statistics to perform ABC under an equilibrium model with recurrent hitchhiking (assuming only beneficial      and neutral mutations) are provided here.

3. Folder: SimulationsTestSet\
   Scripts to perform simulations of specific evolutionary scenarios (referred to here as "test set").

4. Folder: CalculateStatisticsTestSet\
   Scripts to calculate statistics for test sets.

5. Folder: ABCInferenceTestSet\
   Inference of parameters of the test set using the two ABC frameworks described above.
   
6. Folder: PosteriorChecks\
   Scripts to simulate the models that were inferred using ABC above, and then calculate their statistics. This is to perform posterior checks.
   
7. Folder: PlottingFigures\
   Scripts to plot the final figures of the distribution of statistics and the joint posteriors.
