#To perform ABC for ModelRejection using all stats except divergence:
setwd("C:/Users/Parul Johri/Work/ModelRejection/ABC")
library("abc")
library("spatstat", lib.loc="~/R/win-library/3.5")


#Inference of test data set without divergence:
t_demo <- read.table("Stats/demo_100kb_neutral_2000.stats", h=T)
t_par_demo <- t_demo[,c(2:4)]
t_stats_demo <- cbind(t_demo[,c(5:26)]) #without divergence
t_test <- read.table("Stats/testset_100kb_ascertainment_2000.stats", h=T)
t_stats_test <- cbind(t_test[,c(2:23)]) #without divergence


#Take mean of multiple abc runs for neutral demography and store the inference:
rm(t_summary_demo)
rm(t_data_demo)
num_scenarios <- 3
num_reps <- 100
scenario <- 1
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
	if (scenario==1){
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
j <- 1
v_names <- c(paste("Nanc",j,sep=''), paste("Ncur",j,sep=''), paste("Time",j,sep=''))
while(j<num_scenarios){
	j <- j + 1
	v_names <- c(v_names, paste("Nanc",j,sep=''), paste("Ncur",j,sep=''), paste("Time",j,sep=''))
	}
colnames(t_data_demo) <- v_names
write.table(t_summary_demo, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_ascertainment_inference_summary.txt", append=F, sep='\t', quote=F)
write.table(t_data_demo, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/demo_100kb_neutral_2000_ascertainment_inference.txt", append=F, sep='\t', quote=F)
