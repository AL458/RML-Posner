The scripts for running the LR analysis for the Posner task. To run the scripts, you can execute the function Run_RML_analysis_full.m.
This runs the analysis for each participant separately. If supported on your system, the script can run multiple instances of Matlab in parallel to speed up the gradient descent. 
This can be done by first running the script Run_RML_analysis_full_multiple_processes.m.
Afterwards, you can run the gradient descent in multiple Matlab instances by starting the application Run_GD_MMSE in the folder RML/Applications. Here, you can select the number of processes supported, and select run. This will prompt a save location for the gradient descent optimized data. Afterwards, the analysis can be completed by running the script Run_RML_analysis_full_multiple_processes_part2.m.

Data analysis has been performed using Matlab version 2018a. 