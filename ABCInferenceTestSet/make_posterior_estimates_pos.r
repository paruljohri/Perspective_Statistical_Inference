#To make a file with the parameter estimates to perform posterior checks:

#Defining functions:

calculate_f_from_lambda <- function(s_gamma, s_lambda){
	N <- 5000
	mu_neu <- 1e-6

	s_mean <- s_gamma/(2*N)

	#Assuming that the distribution of s follows an exponential distribution:
	Pfix <- function(x) {(1 - exp(-x))/(1 - exp(-2*N*x))}
	Pfixe1 <- function(x) {((1/s_mean)*exp(-1*x*(1/s_mean))*(1 - exp(-x)))/(1 - exp(-2*N*x))} 

	Pfixe2 <- function(x) {(x*(1/s_mean))/(exp(x*(1/s_mean))*(1 - exp(-2*N*x)))}

	#Calculate f:
	Integral1 <- integrate(Pfixe1, lower = 0, upper = Inf)
	Integral2 <- integrate(Pfixe2, lower = 0, upper = Inf)

	f1 <- s_lambda/(((1-s_lambda)*2*N*Integral1$value) + s_lambda)
	f2 <- s_lambda/(((1-s_lambda)*2*N*Integral2$value) + s_lambda)

	return(c(f1,f2))
}

filename <- "eqm_pos_100kb_2000_mu_ben_inference"
#filename <- "eqm_pos_100kb_2000_ascertainment_mu_ben_inference"
t_inf <- read.table(paste("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/", filename,"_summary.txt",sep=''), h=T)
t_inf$scenarioID <- paste("scenario", t_inf$scenario, sep='')
t_f1 <- c()
t_f2 <- c()
num_scenarios <- dim(t_inf)[1]
i <- 1
while (i <= num_scenarios){
	t_tmp <- calculate_f_from_lambda(t_inf$Gamma_mean[i], t_inf$Lambda_mean[i])
	t_f1 <- c(t_f1, t_tmp[1])
	t_f2 <- c(t_f2, t_tmp[2])
	i <- i + 1
}
t_inf$f1 <- t_f1
t_inf$f2 <- t_f2
t_output <- cbind(t_inf$scenarioID, round(t_inf$Gamma_mean), round(t_inf$Lambda_mean,5), round(t_inf$f1,5), round(t_inf$f2,5))
colnames(t_output) <- c("scenarioID", "gamma", "lambda", "f1", "f2")
write.table(t_output, file=paste("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/", filename, "_parameters.txt", sep=''), append=F, sep='\t', quote=F, row.names=F, eol="\n")
