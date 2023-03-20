The scripts for running the LR analysis for the Posner task. To run the scripts, you can simply execute the function Run_RML_analysis_full.m.
Data analysis has been performed using Matlab version 2018a. 
This runs the analysis for each participant separately. If supported on your system, you can try to run the script on multiple threads. 
This can be done by first running the script Run_RML_analysis_full_multiple_threads.m.
Afterwards, you can run the gradient descent in multiple threads by starting the application Run_GD_MMSE in the folder RML/Applications. Here, you can select the number of processes supported, and press run. This will prompt a save location for the gradient descent optimized data. Afterwards, you can run the script Run_RML_analysis_full_multiple_threads_part2.m.