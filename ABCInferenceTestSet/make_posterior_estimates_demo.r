#To make a file with the parameter estimates to perform posterior checks:

filename <- "demo_100kb_neutral_2000_inference"
t_inf <- read.table(paste("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/", filename,"_summary.txt",sep=''), h=T)
t_inf$scenarioID <- paste("scenario", t_inf$scenario, sep='')
t_output <- cbind(t_inf$scenarioID, round(t_inf$Nanc_mean), round(t_inf$Ncur_mean), round(t_inf$Time_mean))
colnames(t_output) <- c("scenarioID", "Nanc", "Ncur", "Time")
write.table(t_output, file=paste("C:/Users/Parul Johri/Work/ModelRejection/ABC/Inference/", filename, "_parameters.txt", sep=''), append=F, sep='\t', quote=F, row.names=F)
