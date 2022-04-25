#To perform ABC for ModelRejection using only means:
setwd("C:/Users/Parul Johri/Work/ModelRejection/ABC")
library("abc")
library("spatstat", lib.loc="~/R/win-library/3.5")


#Read ABC table with mu_ben as a parameter:
t_pos <- read.table("Stats/eqm_pos_100kb_2000.stats", h=T)
t_par_pos <- t_pos[,c(2,30)]
t_stats_pos <- t_pos[,c(4:25)] #without divergence
t_test <- read.table("Stats/testset_100kb_ascertainment_2000.stats", h=T)
t_stats_test <- cbind(t_test[,c(2:23)]) #without divergence



#Perform inferenece - Take mean of multiple abc runs:
#When using mu_ben as a parameter:
mu_tot <- 1e-6
num_gen <- 50100
rm(t_data_pos)
rm(t_summary_pos)
num_scenarios <- 3
num_reps <- 100
scenario <- 1
while (scenario <= num_scenarios){
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
		i <- i + 1
	}
	if (scenario==1){
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
j <- 1
v_names <- c(paste("gamma",j,sep=''), paste("lambda",j,sep=''))
while(j<num_scenarios){
	j <- j + 1
	v_names <- c(v_names, paste("gamma",j,sep=''), paste("lambda",j,sep=''))
	}
colnames(t_data_pos) <- v_names
write.table(t_summary_pos, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_ascertainment_mu_ben_inference_summary.txt", append=F, sep='\t', quote=F)
write.table(t_data_pos, file="C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/eqm_pos_100kb_2000_ascertainment_mu_ben_inference.txt", append=F, sep='\t', quote=F)

