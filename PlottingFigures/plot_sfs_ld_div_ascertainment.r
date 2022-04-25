#This is to plot the stats for the perspective:
#SFS, LD and Divergence
#It'll be ploted per replicate- that is 100 points will be shown.

setwd("C:/Users/Parul Johri/Work/ModelRejection/Statistics/TrueModel")


folder <- "decline_dfe_pos10x_exon50_100kb_const_rates"
folder <- "growth2fold_dfe_pos10x_exon50_100kb_const_rates"

#Plotting the SFS upto some class (Truncated SFS):
freq_cutoff <- 20
x_names <- seq(1,freq_cutoff)
t_sfs <- read.table(paste(folder, "_stats/", folder, "_singletons_100_freq.sfs", sep=''), h=T)
t_tmp1 <- t_sfs[,c(2:(freq_cutoff+1))]
t_tmp2 <- rbind(colMeans(t_tmp1))
data <- data.matrix(t_tmp2)
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/SFS/TruncatedSFS/20indv/", folder,"_singletons.pdf", sep=""), width=5, height=4)
data.bar <- barplot(data, beside=T, col="black", ylab="Frequency", names.arg=x_names, xpd=F, cex.lab=1.5, cex.names=1.5, cex.axis=1.5, ylim=c(0,0.50))
dev.off()

freq_cutoff <- 50
x_names <- seq(1,freq_cutoff)
t_sfs <- read.table(paste(folder, "_stats/", folder, "_singletons_100_freq.sfs", sep=''), h=T)
t_tmp1 <- t_sfs[,c(2:(freq_cutoff+1))]
t_tmp2 <- rbind(colMeans(t_tmp1))
data <- data.matrix(t_tmp2)
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/SFS/TruncatedSFS/50indv/", folder,"_singletons.pdf", sep=""), width=5, height=4)
data.bar <- barplot(data, beside=T, col="black", ylab="Frequency", names.arg=x_names, xpd=F, cex.lab=1.5, cex.names=1.0, cex.axis=1.5, ylim=c(0,0.50))
dev.off()


#Plotting the distribution of LD:
xmin <- 0.0
xmax <- 0.2
ymin <- 0
ymax <- 45
xname=expression(paste(italic(r)^2))
v_folders <- c("growth2fold_dfe_pos10x_exon50_100kb_const_rates")
for (folder in v_folders){
	t_ld <- read.table(paste(folder, "_stats/", folder, "_singletons_2000.stats", sep=''), h=T)
	t_means <- aggregate(t_ld$rsq~t_ld$filename, FUN=mean)
	pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/LD/", folder,"_singletons.pdf", sep=""), width=5, height=4)
	ld_plot <- hist(t_means$`t_ld$rsq`, main="", ylab="Counts", xlab=xname, col="grey", cex.lab=1.5, cex.axis=1.5, xlim=c(xmin, xmax), ylim=c(ymin, ymax))
	dev.off()
}
#Plotting the distribution of divergence:
xmin <- 0.030
xmax <- 0.080
ymin <- 0
ymax <- 35
v_folders <- c("growth2fold_dfe_pos10x_exon50_100kb_const_rates")
for (folder in v_folders){
	t_div <- read.table(paste(folder, "_stats/", folder, "_singletons.divergence", sep=''), h=T)
	pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/Divergence/", folder,"_singletons.pdf", sep=""), width=5, height=4)
	hist(t_div$div_per_site, main="", ylab="Counts", xlab="Divergence per site", col="grey", cex.lab=1.5, cex.axis=1.5, xlim=c(xmin, xmax), ylim=c(ymin, ymax))
	dev.off()
	}
