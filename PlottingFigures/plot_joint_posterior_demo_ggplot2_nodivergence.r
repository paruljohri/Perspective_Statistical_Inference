#To make joint posteriors for infernece in ABC:
setwd("C:/Users/Parul Johri/Work/ModelRejection/ABC")
library("ggplot2", lib.loc="~/R/win-library/3.5")

#Read the inference:
t_data_demo <- read.table("Inference/demo_100kb_neutral_2000_inference.txt", h=T)

#Read test dataset:
t_test <- read.table("Stats/testset_100kb_2000.stats", h=T)


#Figure 1:
v_scenarios <- c(2, 5, 34) #used to be 10
#Figure 2:
v_scenarios <- c(17)
#Figure 3:
v_scenarios <- c(18, 19)
#Figure 4:
v_scenarios <- c(5, 10, 17, 21, 23, 25)


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
	return(c(true_Na, true_Nc, true_gamma, true_lambda))
}

#Figure 1:
#v_scenarios <- c(2, 5, 34)
scenario <- 2
t_tmp <- get_true_values(scenario)
true_Na <- t_tmp[1]
true_Nc <- t_tmp[2]
col_Nanc <- 3*scenario-2
col_Ncur <- 3*scenario-1
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/JointPosteriors/Demo/Figure1/", t_test$scenario[scenario],".pdf", sep=""), width=5, height=4)
xname=expression(paste("Ancestral ", italic(N), sep=" "))
yname=expression(paste("Current ", italic(N), sep=" "))
ggd <- ggplot(t_data_demo, aes(x = t_data_demo[,(col_Nanc)], y = t_data_demo[,(col_Ncur)])) + labs(x=xname, y=yname)
ggd1 <- ggd + xlim(50, 7000) + ylim(50, 48000) + theme_classic() + theme(plot.margin = margin(t=0.3,r=0.3,b=0.3,l=0.3, unit="cm"), axis.text=element_text(size=rel(2)), axis.title=element_text(size=rel(2)))
ggd2 <- ggd1 + geom_point(aes(x=true_Na, y=true_Nc), color="red", size=4, shape=4, stroke=1.5)
ggd3 <- ggd2 + geom_density_2d(stat = "density_2d", color="black") # contour lines
plot(ggd3)
dev.off()

#Figure 2:
scenario <- 17
t_tmp <- get_true_values(scenario)
true_Na <- t_tmp[1]
true_Nc <- t_tmp[2]
col_Nanc <- 3*scenario-2
col_Ncur <- 3*scenario-1
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/JointPosteriors/Demo/Figure2/", t_test$scenario[scenario],".pdf", sep=""), width=5, height=4)
xname=expression(paste("Ancestral ", italic(N), sep=" "))
yname=expression(paste("Current ", italic(N), sep=" "))
ggd <- ggplot(t_data_demo, aes(x = t_data_demo[,(col_Nanc)], y = t_data_demo[,(col_Ncur)])) + labs(x=xname, y=yname)
ggd1 <- ggd + xlim(50, 7000) + ylim(50, 25000) + theme_classic() + theme(plot.margin = margin(t=0.3,r=0.3,b=0.3,l=0.3, unit="cm"), axis.text=element_text(size=rel(2)), axis.title=element_text(size=rel(2)))
ggd2 <- ggd1 + geom_density_2d(stat = "density_2d", color="black") # contour lines
ggd3 <- ggd2 + geom_point(aes(x=true_Na, y=true_Nc), color="red", size=4, shape=4, stroke=1.5)
plot(ggd3)
dev.off()

#Figure 3:
#v_scenarios <- c(18, 19)
scenario <- 18
t_tmp <- get_true_values(scenario)
true_Na <- t_tmp[1]
true_Nc <- t_tmp[2]
col_Nanc <- 3*scenario-2
col_Ncur <- 3*scenario-1
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/JointPosteriors/Demo/Figure3/", t_test$scenario[scenario],".pdf", sep=""), width=5, height=4)
xname=expression(paste("Ancestral ", italic(N), sep=" "))
yname=expression(paste("Current ", italic(N), sep=" "))
ggd <- ggplot(t_data_demo, aes(x = t_data_demo[,(col_Nanc)], y = t_data_demo[,(col_Ncur)])) + labs(x=xname, y=yname)
ggd1 <- ggd + xlim(50, 6000) + ylim(50, 20000) + theme_classic() + theme(plot.margin = margin(t=0.3,r=0.8,b=0.3,l=0.3, unit="cm"), axis.text=element_text(size=rel(2)), axis.title=element_text(size=rel(2)))
ggd2 <- ggd1 + geom_density_2d(stat = "density_2d", color="black") # contour lines
ggd3 <- ggd2 + geom_point(aes(x=true_Na, y=true_Nc), color="red", size=4, shape=4, stroke=1.5)
plot(ggd3)
dev.off()

#Figure 4:
#v_scenarios <- c(5, 10, 17, 21, 23, 25)
scenario <- 25
t_tmp <- get_true_values(scenario)
true_Na <- t_tmp[1]
true_Nc <- t_tmp[2]
col_Nanc <- 3*scenario-2
col_Ncur <- 3*scenario-1
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/JointPosteriors/Demo/Figure4/", t_test$scenario[scenario],".pdf", sep=""), width=5, height=4)
xname=expression(paste("Ancestral ", italic(N), sep=" "))
yname=expression(paste("Current ", italic(N), sep=" "))
ggd <- ggplot(t_data_demo, aes(x = t_data_demo[,(col_Nanc)], y = t_data_demo[,(col_Ncur)])) + labs(x=xname, y=yname)
ggd1 <- ggd + xlim(50, 14000) + ylim(50, 35000) + theme_classic() + theme(plot.margin = margin(t=0.3,r=0.3,b=0.3,l=0.3, unit="cm"), axis.text=element_text(size=rel(2)), axis.title=element_text(size=rel(2)))
ggd2 <- ggd1 + geom_density_2d(stat = "density_2d", color="black") # contour lines
ggd3 <- ggd2 + geom_point(aes(x=true_Na, y=true_Nc), color="red", size=4, shape=4, stroke=1.5)
plot(ggd3)
dev.off()

