# Study-of-Event-driven-and-periodic-rescheduling-policies
Matlab source code for the paper "Study of event-driven and periodic rescheduling  on a single machine with unexpected disruptions"  
http://www.ijmp.jor.br/index.php/ijmp/article/view/838
#####################################################################################################################################
1. Run the rescheduling algorithm from "Main" file.
2. Set Genetic Algorithm parameters in "Run_ABZ5_100_random" file.
3. Jobs processing time and due dates are listed in "10 Jobs info" and "25 Jobs info"
	--> First column represents the processing time for each job.
	--> Second column through fourth represents due dates with loose, normal, and tight due dates respectively.
4. Total cost results are stored in variable "results_cost".
5. Total tardiness results are stored in variable "results_tardiness".
6. The main file reads the designed experiment trials from "Rescheduling Experiment" file.
	--> In this file, each column represents a factor.
	--> Each row represents and experimental trial in which a combination of different factors' levels are tested.
