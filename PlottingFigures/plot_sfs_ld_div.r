#This is to plot the stats for the perspective:
#SFS, LD and Divergence
#It'll be ploted per replicate- that is 100 points will be shown.

setwd("C:/Users/Parul Johri/Work/ModelRejection/Statistics/TrueModel")

folder <- "eqm_dfe_exon50_100kb_const_rates"
folder <- "eqm_dfe_pos10x_exon50_100kb_const_rates"
folder <- "bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates_2000gen"

folder <- "growth2fold_dfe_pos10x_exon50_100kb_const_rates"

folder <- "eqm_dfe_exon50_100kb_const_rates_psi0_05"
folder <- "eqm_dfe_exon50_100kb_const_rates_psi0_1"

folder <- "eqm_dfe_pos10x_exon50_100kb_var_rates"
folder <- "decline_dfe_pos10x_exon50_100kb_const_rates"
folder <- "decline_dfe_pos10x_exon50_100kb_var_rates"
folder <- "growth2fold_dfe_pos10x_exon50_100kb_var_rates"

v_folders <- c("eqm_dfe_exon50_100kb_const_rates",
	"eqm_dfe_pos10x_exon50_100kb_const_rates",
	"bot100gen1sev_dfe_pos10x_exon50_100kb_const_rates_2000gen",
	"growth2fold_dfe_pos10x_exon50_100kb_const_rates",
	"eqm_dfe_exon50_100kb_const_rates_psi0_05",
	"eqm_dfe_exon50_100kb_const_rates_psi0_1")



#Plotting the SFS while binning the last class:
#ylim as 0.85 for 10 individuals.
#ylim as 0.70 for 20 individuals.
#ylim as 0.50 for 50 individuals.
freq_cutoff <- 20
x_names <- c(seq(1,freq_cutoff-1),paste(">",freq_cutoff-1, sep=""))
t_sfs <- read.table(paste(folder, "_stats/", folder, "_100_m5_freq.sfs", sep=''), h=T)
t_tmp1 <- cbind(t_sfs[,c(2:freq_cutoff)], rowSums(t_sfs[,c((freq_cutoff+1):dim(t_sfs)[2])]))
t_tmp2 <- rbind(colMeans(t_tmp1))
data <- data.matrix(t_tmp2)
data.bar <- barplot(data, beside=T, col="black", ylab="Frequency", names.arg=x_names, xpd=F, cex.lab=1.5, cex.names=1.0, cex.axis=1.5, ylim=c(0,0.70))

freq_cutoff <- 50
x_names <- c(seq(1,freq_cutoff-1),paste(">",freq_cutoff-1, sep=""))
t_sfs <- read.table(paste(folder, "_stats/", folder, "_100_m5_freq.sfs", sep=''), h=T)
t_tmp1 <- cbind(t_sfs[,c(2:freq_cutoff)], rowSums(t_sfs[,c((freq_cutoff+1):dim(t_sfs)[2])]))
t_tmp2 <- rbind(colMeans(t_tmp1))
data <- data.matrix(t_tmp2)
data.bar <- barplot(data, beside=T, col="black", ylab="Frequency", names.arg=x_names, xpd=F, cex.lab=1.5, cex.names=1.0, cex.axis=1.5, ylim=c(0,0.50))

#Plotting the SFS upto some class (Truncated SFS):
freq_cutoff <- 20
x_names <- seq(1,freq_cutoff)
for (folder in v_folders){
	t_sfs <- read.table(paste(folder, "_stats/", folder, "_100_m5_freq.sfs", sep=''), h=T)
	t_tmp1 <- t_sfs[,c(2:(freq_cutoff+1))]
	t_tmp2 <- rbind(colMeans(t_tmp1))
	data <- data.matrix(t_tmp2)
	pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/SFS/TruncatedSFS/20indv/", folder,".pdf", sep=""), width=5, height=4)
	data.bar <- barplot(data, beside=T, col="black", ylab="Frequency", names.arg=x_names, xpd=F, cex.lab=1.5, cex.names=1.5, cex.axis=1.5, ylim=c(0,0.50))
	dev.off()
	}

freq_cutoff <- 50
x_names <- seq(1,freq_cutoff)
t_sfs <- read.table(paste(folder, "_stats/", folder, "_100_m5_freq.sfs", sep=''), h=T)
t_tmp1 <- t_sfs[,c(2:(freq_cutoff+1))]
t_tmp2 <- rbind(colMeans(t_tmp1))
data <- data.matrix(t_tmp2)
pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/SFS/TruncatedSFS/50indv/", folder,".pdf", sep=""), width=5, height=4)
data.bar <- barplot(data, beside=T, col="black", ylab="Frequency", names.arg=x_names, xpd=F, cex.lab=1.5, cex.names=1.0, cex.axis=1.5, ylim=c(0,0.50))
dev.off()


#Plotting the distribution of LD:
xmin <- 0.0
xmax <- 0.2
ymin <- 0
ymax <- 45
xname=expression(paste(italic(r)^2))
for (folder in v_folders){
	t_ld <- read.table(paste(folder, "_stats/", folder, "_2000.stats", sep=''), h=T)
	t_means <- aggregate(t_ld$rsq~t_ld$filename, FUN=mean)
	pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/LD/", folder,".pdf", sep=""), width=5, height=4)
	ld_plot <- hist(t_means$`t_ld$rsq`, main="", ylab="Counts", xlab=xname, col="grey", cex.lab=1.5, cex.axis=1.5, xlim=c(xmin, xmax), ylim=c(ymin, ymax))
	dev.off()
}
#Plotting the distribution of divergence:
xmin <- 0.030
xmax <- 0.080
ymin <- 0
ymax <- 35
for (folder in v_folders){
	t_div <- read.table(paste(folder, "_stats/", folder, ".divergence", sep=''), h=T)
	pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/Divergence/", folder,".pdf", sep=""), width=5, height=4)
	hist(t_div$div_per_site, main="", ylab="Counts", xlab="Divergence per site", col="grey", cex.lab=1.5, cex.axis=1.5, xlim=c(xmin, xmax), ylim=c(ymin, ymax))
	dev.off()
	}

xmin <- 0.0
xmax <- 0.00025
ymin <- 0
ymax <- 50
v_folders <- c("eqm_dfe_exon50_100kb_const_rates_psi0_05", "eqm_dfe_exon50_100kb_const_rates_psi0_1")
for (folder in v_folders){
	t_div <- read.table(paste(folder, "_stats/", folder, ".divergence", sep=''), h=T)
	pdf(paste("C:/Users/Parul Johri/Work/ModelRejection/plots/Divergence/", folder,".pdf", sep=""), width=5, height=4)
	hist(t_div$div_per_site, main="", ylab="Counts", xlab="Divergence per site", col="grey", cex.lab=1.5, cex.axis=1.5, xlim=c(xmin, xmax), ylim=c(ymin, ymax))
	dev.off()
	}