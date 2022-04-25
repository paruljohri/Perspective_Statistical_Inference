#To perform ABC for ModelRejection using only means:
setwd("C:/Users/Parul Johri/Work/ModelRejection/ABC")
library("abc")
library("spatstat", lib.loc="~/R/win-library/3.5")


#Read ABC table with mu_ben as a parameter:
t_pos <- read.table("Stats/eqm_pos_100kb_2000.stats", h=T)
t_par_pos <- t_pos[,c(2,30)]
t_stats_pos <- t_pos[,c(4:25)] #without divergence
t_test <- read.table("Stats/testset_100kb_2000.stats", h=T)
t_stats_test <- cbind(t_test[,c(2:23)]) #without divergence

#cross-validation to test tolerance:
#290 points
cv_nnet <- cv4abc(t_par_pos, t_stats_pos, nval=100, tols=c(0.01, 0.03, 0.05, 0.08), statistic="mean", method="neuralnet", transf="none")
cv_nnet <- cv4abc(t_par_pos, t_stats_pos, nval=100, tols=c(0.05), statistic="mean", method="neuralnet", transf="none")
summary(cv_nnet)
plot(cv_nnet)


#CV with Lambda as a parameter:
Prediction error based on a cross-validation sample of 100

         gamma lambda_mean
0.01 0.1535337   1.5956268
0.03 0.1591411   0.8148560
0.05 0.1872004   0.6700524
0.08 0.2657876   0.5876593

#CV with mu_ben as a parameter:
Prediction error based on a cross-validation sample of 100

          gamma mu_ben_mean
0.01 0.22067395  0.13799514
0.03 0.18814663  0.06897537
0.05 0.21508799  0.07174888
0.08 0.38444419  0.21613717


#Perform inferenece - Take mean of multiple abc runs:
#When using mu_ben as a parameter:
mu_tot <- 1e-6
num_gen <- 50100
rm(t_data_pos)
rm(t_summary_pos)
num_scenarios <- dim(t_test)[1]
scenario_start <-1 #change this!
num_reps <- 100
scenario <- scenario_start
while (scenario <= num_scenarios){
	if(scenario==29){num_gen <- 51000}
	if(scenario==30){num_gen <- 52000}
	if(scenario>=31){num_gen <- 51000}
	Gamma <- c() 
	Lambda <- c()
	i <- 1
	while(i<=num_reps){
		abc_nnet_pos <- abc(target=t_stats_test[scenario,], param=t_par_pos, sumstat=t_stats_pos, tol=0.05, method="neuralnet")
		#calculating errors:
		est1 <- weighted.median(abc_nnet_pos$adj.values[,1], abc_nnet_pos$weights, na.rm = TRUE)
		est2 <- weighted.median(abc_nnet_pos$adj.values[,2], abc_nnet_pos$weights, na.rm = TRUE)
		if (est1 < 0){est1 <- 0}
		if (est2 < 0){est2 <- 0}
		Gamma <- c(Gamma, est1)
		Lambda <- c(Lambda, (est2/(est2 + (num_gen*mu_tot))))
		#Lambda <- c(Lambda, (est2/num_gen/mu_tot))#this is the older one
		i <- i + 1
	}
	if (scenario==scenario_start){
		t_data_pos <- data.frame(cbind(Gamma, Lambda))
		t_summary_pos <- data.frame(cbind(scenario, mean(Gamma), min(Gamma), max(Gamma), mean(Lambda), min(Lambda), max(Lambda)))
	}
	else{
		t_data_pos <- cbind(t_data_pos, Gamma, Lambda)
		t_summary_pos <- rbind(t_summary_pos, data.frame(cbind(scenario, mean(Gamma), min(Gamma), max(Gamma), mean(Lambda), min(Lambda), max(Lambda))))
	}
	scenario <- scenario + 1
}
colnames(t_summary_pos) <- c("scenario", "Gamma_mean", "Gamma_min", "Gamma_max", "Lambda_mean", "Lambda_min", "Lambda_max")
j <- scenario_start
v_names <- c(paste("gamma",j,sep=''), paste("lambda",j,sep=''))
while(j<num_scenarios){
	j <- j + 1
	v_names <- c(v_names, paste("gamma",j,sep=''), paste("lambda",j,sep=''))
	}
colnames(t_data_pos) <- v_names

#To write into a new file, when perforimg inference for all scenarios
write.table(t_summary_pos, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_mu_ben_inference_summary.txt", append=F, sep='\t', quote=F)
write.table(t_data_pos, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_mu_ben_inference.txt", append=F, sep='\t', quote=F)

#To append new inferences to existing ones:
t_data_pos_old <- read.table("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_mu_ben_inference.txt", h=T)
t_summary_pos_old <- read.table("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_mu_ben_inference_summary.txt", h=T)
t_data_pos_new <- cbind(t_data_pos_old, t_data_pos)
t_summary_pos_new <- rbind(t_summary_pos_old, t_summary_pos)
write.table(t_data_pos_new, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_mu_ben_inference.txt", append=F, sep='\t', quote=F, row.names=F)
write.table(t_summary_pos_new, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_mu_ben_inference_summary.txt", append=F, sep='\t', quote=F, row.names=F)

