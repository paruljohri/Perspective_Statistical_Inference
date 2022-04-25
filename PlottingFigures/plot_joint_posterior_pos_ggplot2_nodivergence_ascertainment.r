#To make joint posteriors for infernece in ABC:
setwd("C:/Users/Parul Johri/Work/ModelRejection/ABC")
library("ggplot2", lib.loc="~/R/win-library/3.5")

#Read the inference:
t_data_pos <- read.table("Inference/eqm_pos_100kb_2000_ascertainment_mu_ben_inference.txt", h=T)

#Read test dataset:
t_test <- read.table("Stats/testset_100kb_ascertainment_2000.stats", h=T)



#Get true values:
get_true_values <- function(scenario){
	if (length(grep("eqm", t_test[scenario,1]))>0){
		true_Na <- 5000
		true_Nc <- 5000
	}else if (length(grep("decline", t_test[scenario,1]))>0){
		true_Na <- 5000
		true_Nc <- 100
	}else if (length(grep("growth2fold", t_test[scenario,1]))>0){
		true_Na <- 5000
		true_Nc <- 10000
	}
	if (length(grep("pos", t_test[scenario,1]))>0){
		true_gamma <- 125
	}else {true_gamma <- 0
	}
	true_lambda <- t_test$lambda_mean[scenario]
	return(c(true_gamma, true_lambda))
}



#Figure 2:
scenario <- 3
t_tmp <- get_true_values(scenario)
true_gamma <- t_tmp[1]
true_lambda <- t_tmp[2]
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/JointPosteriors/Pos/Figure2/", t_test$scenario[scenario],".pdf", sep=""), width=5, height=4)
xname=expression(paste(italic(gamma)))
yname=expression(paste(italic(lambda)))
ggp <- ggplot(t_data_pos, aes(x = t_data_pos[,(2*scenario-1)], y = t_data_pos[,(2*scenario)])) + labs(x=xname, y=yname)
ggp1 <- ggp + geom_point(aes(x=true_gamma, y=true_lambda), color="red", size=4, shape=4, stroke=1.5)
ggp2 <- ggp1 + xlim(0.0, 200) + ylim(0.0, 0.5) + theme_classic()+ theme(plot.margin = margin(t=0.3,r=0.3,b=0.3,l=0.3, unit="cm"), axis.text=element_text(size=rel(2)), axis.title=element_text(size=rel(2)))
ggp3 <- ggp2 + geom_density_2d(stat = "density_2d", color="black") # contour lines
plot(ggp3)
dev.off()

