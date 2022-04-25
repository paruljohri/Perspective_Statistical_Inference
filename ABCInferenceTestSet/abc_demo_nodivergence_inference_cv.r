#To perform ABC for ModelRejection using all stats except divergence:
setwd("C:/Users/Parul Johri/Work/ModelRejection/ABC")
library("abc")
library("spatstat", lib.loc="~/R/win-library/3.5")


#Inference of test data set without divergence:
t_demo <- read.table("Stats/demo_100kb_neutral_2000.stats", h=T)
t_par_demo <- t_demo[,c(2:4)]
t_stats_demo <- cbind(t_demo[,c(5:26)]) #without divergence
t_test <- read.table("Stats/testset_100kb_2000.stats", h=T)
t_stats_test <- cbind(t_test[,c(2:23)]) #without divergence


#834 points when time is included as a parameter.
#cross-validation to test tolerance:
cv_nnet <- cv4abc(t_par_demo, t_stats_demo, nval=100, tols=c(0.01, 0.03, 0.05, 0.08), statistic="mean", method="neuralnet", transf="none")
summary(cv_nnet)
par(mfcol=c(1,3))
par(mar=c(4,4,2,1))
plot(cv_nnet)
Prediction error based on a cross-validation sample of 100

            Nanc        Ncur        Time
0.01 0.005347283 0.145297719 1.698277894
0.03 0.010352020 0.184155310 0.310364847
0.05 0.012914290 0.144770499 0.321932591
0.08 0.018469788 0.184788300 0.960517534

#Neural net inference using a single instance:
scenario <- 2
abc_nnet_demo <- abc(target=t_stats_test[scenario,], param=t_par_demo, sumstat=t_stats_demo, tol=0.05, method="neuralnet")
summary(abc_nnet_demo)

#Take mean of multiple abc runs for neutral demography and store the inference:
rm(t_summary_demo)
rm(t_data_demo)
num_scenarios <- dim(t_test)[1]
num_reps <- 100
scenario_start <- 31
scenario <- scenario_start
while (scenario <= num_scenarios){
	Nanc <- c() 
	Ncur <- c()
	Time <- c()
	i <- 1
	while(i<=num_reps){
		abc_nnet_demo <- abc(target=t_stats_test[scenario,], param=t_par_demo, sumstat=t_stats_demo, tol=0.05, method="neuralnet")
		#calculating errors:
		est1 <- weighted.median(abc_nnet_demo$adj.values[,1], abc_nnet_demo$weights, na.rm = TRUE)
		est2 <- weighted.median(abc_nnet_demo$adj.values[,2], abc_nnet_demo$weights, na.rm = TRUE)
		est3 <- weighted.median(abc_nnet_demo$adj.values[,3], abc_nnet_demo$weights, na.rm = TRUE)
		if (est1 < 0){est1 <- 0}
		if (est2 < 0){est2 <- 0}
		if (est3 < 0){est3 <- 0}
		Nanc <- c(Nanc, est1)
		Ncur <- c(Ncur, est2)
		Time <- c(Time, est3)
		i <- i + 1
	}
	if (scenario==scenario_start){
		t_data_demo <- data.frame(cbind(Nanc, Ncur, Time))
		t_summary_demo <- data.frame(cbind(scenario, mean(Nanc), min(Nanc), max(Nanc), mean(Ncur), min(Ncur), max(Ncur), mean(Time), min(Time), max(Time)))
	}
	else{
		t_data_demo <- cbind(t_data_demo, Nanc, Ncur, Time)
		t_summary_demo <- rbind(t_summary_demo, data.frame(cbind(scenario, mean(Nanc), min(Nanc), max(Nanc), mean(Ncur), min(Ncur), max(Ncur), mean(Time), min(Time), max(Time))))
	}
	scenario <- scenario + 1
}
colnames(t_summary_demo) <- c("scenario", "Nanc_mean", "Nanc_min", "Nanc_max", "Ncur_mean", "Ncur_min", "Ncur_max", "Time_mean", "Time_min", "Time_max")
j <- scenario_start
v_names <- c(paste("Nanc",j,sep=''), paste("Ncur",j,sep=''), paste("Time",j,sep=''))
while(j<num_scenarios){
	j <- j + 1
	v_names <- c(v_names, paste("Nanc",j,sep=''), paste("Ncur",j,sep=''), paste("Time",j,sep=''))
	}
colnames(t_data_demo) <- v_names

#To write into a new file, when perforimg inference for all scenarios
write.table(t_summary_demo, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_inference_summary.txt", append=F, sep='\t', quote=F, row.names=F)
write.table(t_data_demo, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_inference.txt", append=F, sep='\t', quote=F, row.names=F)

#To append new inferences to existing ones:
t_data_demo_old <- read.table("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_inference.txt", h=T)
t_summary_demo_old <- read.table("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_inference_summary.txt", h=T)
t_data_demo_new <- cbind(t_data_demo_old, t_data_demo)
t_summary_demo_new <- rbind(t_summary_demo_old, t_summary_demo)
write.table(t_summary_demo_new, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_inference_summary.txt", append=F, sep='\t', quote=F, row.names=F)
write.table(t_data_demo_new, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_inference.txt", append=F, sep='\t', quote=F, row.names=F)
