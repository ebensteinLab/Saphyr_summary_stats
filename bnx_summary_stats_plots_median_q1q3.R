library(tidyverse)
library(cowplot)
setwd("D:/Sapir/PhD/GM12878 analysis/summary stats for all files")
file_name=c("F3P1_bnx_summary.txt")

'2 colors:'
summary_stats <- read_tsv(file_name)
summary_stats <- summary_stats %>% 
  mutate(c1_density = num_labels_c1 / length * 100000, c2_density = num_labels_c2 / length * 100000)

summary_stats_filter_length <- summary_stats %>% filter(length >= 150000)

density_summary <- summary_stats_filter_length %>% 
  group_by(scan) %>% 
  summarise(num_mols=n(),
            mean_len = mean(length), len_sd=sd(length), len_median=median(length),len_q1=quantile(length, .25),len_q3=quantile(length, .75),
            c1_den_mean=mean(c1_density),c1_sd=sd(c1_density),c1_den_median=median(c1_density),c1_den_q1=quantile(c1_density, .25),
            c1_den_q3=quantile(c1_density, .75),
            c2_den_mean=mean(c2_density),c2_sd=sd(c2_density),c2_den_median=median(c2_density),c2_den_q1=quantile(c2_density, .25),
            c2_den_q3=quantile(c2_density, .75),
            yoyo=mean(yoyo_avg_intensity), yoyo_sd=sd(yoyo_avg_intensity),yoyo_median=median(yoyo_avg_intensity),
            yoyo_q1=quantile(yoyo_avg_intensity,.25),yoyo_q3=quantile(yoyo_avg_intensity,.75))

p1 <- ggplot(density_summary,aes(x=as.numeric(scan),y=num_mols)) + geom_point()+xlab("scan")+ylab("number of molecules")+
  ggtitle("no. of molecules per scan")+ theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p2 <- ggplot(density_summary,aes(x=as.numeric(scan),y=len_median)) + geom_point()+
  geom_errorbar(aes(ymin=len_q1,ymax=len_q3))+xlab("scan")+ylab("molecules length (q1,median,q3)")+
  ggtitle("molecules length per scan")+   theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p3 <- ggplot(density_summary,aes(x=as.numeric(scan),y=c1_den_median)) + geom_point(color="green")+
  geom_errorbar(aes(ymin=c1_den_q1,ymax=c1_den_q3),color="green")+xlab("scan")+ylab("green label density (q1,median,q3)")+
  ggtitle("green label density per scan")+   theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p4 <- ggplot(density_summary,aes(x=as.numeric(scan),y=c2_den_median)) + geom_point(color="red")+ 
  geom_errorbar(aes(ymin=c2_den_q1,ymax=c2_den_q3),color="red")+xlab("scan")+ylab("red label density (q1,median,q3)")+
  ggtitle("red label density per scan")+  theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p5<- ggplot(density_summary,aes(x=as.numeric(scan),y=yoyo_median)) + geom_point(color="blue")+
  geom_errorbar(aes(ymin=yoyo_q1,ymax=yoyo_q3),color="blue")+xlab("scan")+ylab("yoyo average intensity in molecule \n (q1,median,q3 per scan)")+
  ggtitle("yoyo average intensity per scan")+ theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))


grid1<-plot_grid(p2, p5, p3, p4)
grid_suff<-"grid_plot"
grid_file_name<-paste(file_name,grid_suff,".png",sep="_")
save_plot(grid_file_name,grid1,base_aspect_ratio = 1.5)

p1
p1_suff<-"num_of_molecules"
p1_file_name<-paste(file_name,p1_suff,".png",sep="_")
save_plot(p1_file_name,p1,base_aspect_ratio = 1.5)


'for 1 color:'

summary_stats <- read_tsv(file_name)
summary_stats <- summary_stats %>% 
  mutate(c1_density = num_labels_c1 / length * 100000)

summary_stats_filter_length <- summary_stats %>% filter(length >= 150000)

density_summary <- summary_stats_filter_length %>% 
  group_by(scan) %>% 
summarise(num_mols=n(),
mean_len = mean(length), len_sd=sd(length), len_median=median(length),len_q1=quantile(length, .25),len_q3=quantile(length, .75),
c1_den_mean=mean(c1_density),c1_sd=sd(c1_density),c1_den_median=median(c1_density),c1_den_q1=quantile(c1_density, .25),
c1_den_q3=quantile(c1_density, .75),
yoyo=mean(yoyo_avg_intensity), yoyo_sd=sd(yoyo_avg_intensity),yoyo_median=median(yoyo_avg_intensity),
yoyo_q1=quantile(yoyo_avg_intensity,.25),yoyo_q3=quantile(yoyo_avg_intensity,.75))

p1 <- ggplot(density_summary,aes(x=as.numeric(scan),y=num_mols)) + geom_point()+xlab("scan")+ylab("number of molecules")+
ggtitle("no. of molecules per scan")+ theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p2 <- ggplot(density_summary,aes(x=as.numeric(scan),y=len_median)) + geom_point()+
geom_errorbar(aes(ymin=len_q1,ymax=len_q3))+xlab("scan")+ylab("molecules length (q1,median,q3)")+
ggtitle("molecules length per scan")+   theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p3 <- ggplot(density_summary,aes(x=as.numeric(scan),y=c1_den_median)) + geom_point(color="green")+
geom_errorbar(aes(ymin=c1_den_q1,ymax=c1_den_q3),color="green")+xlab("scan")+ylab("green label density (q1,median,q3)")+
ggtitle("green label density per scan")+   theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))

p5<- ggplot(density_summary,aes(x=as.numeric(scan),y=yoyo_median)) + geom_point(color="blue")+
geom_errorbar(aes(ymin=yoyo_q1,ymax=yoyo_q3),color="blue")+xlab("scan")+ylab("yoyo average intensity in molecule \n (q1,median,q3 per scan)")+
ggtitle("yoyo average intensity per scan")+ theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))

grid1<-plot_grid(p2, p5, p3)
grid_suff<-"grid_plot"
grid_file_name<-paste(file_name,grid_suff,".png",sep="_")
save_plot(grid_file_name,grid1,base_aspect_ratio = 1.5)

p1
p1_suff<-"num_of_molecules"
p1_file_name<-paste(file_name,p1_suff,".png",sep="_")
save_plot(p1_file_name,p1,base_aspect_ratio = 1.5)

'for RunID-based:'
summary_stats <- read_tsv(file_name)
summary_stats <- summary_stats %>% 
  mutate(c1_density = NumLabels1 / Length * 100000, c2_density = NumLabels2 / Length * 100000)

summary_stats_filter_length <- summary_stats %>% filter(Length >= 150000)

density_summary <- summary_stats_filter_length %>% 
  group_by(RunID) %>% 
  summarise(num_mols=n(),
            mean_len = mean(Length), len_sd=sd(Length), len_median=median(Length),len_q1=quantile(Length, .25),len_q3=quantile(Length, .75),
            c1_den_mean=mean(c1_density),c1_sd=sd(c1_density),c1_den_median=median(c1_density),c1_den_q1=quantile(c1_density, .25),
            c1_den_q3=quantile(c1_density, .75),
            c2_den_mean=mean(c2_density),c2_sd=sd(c2_density),c2_den_median=median(c2_density),c2_den_q1=quantile(c2_density, .25),
            c2_den_q3=quantile(c2_density, .75),
            yoyo=mean(Yoyo), yoyo_sd=sd(Yoyo),yoyo_median=median(Yoyo),
            yoyo_q1=quantile(Yoyo,.25),yoyo_q3=quantile(Yoyo,.75))

p1 <- ggplot(density_summary,aes(x=as.numeric(RunID),y=num_mols)) + geom_point()+xlab("run")+ylab("number of molecules")+
  ggtitle("no. of molecules per run")+ theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p2 <- ggplot(density_summary,aes(x=as.numeric(RunID),y=len_median)) + geom_point()+
  geom_errorbar(aes(ymin=len_q1,ymax=len_q3))+xlab("run")+ylab("molecules length (q1,median,q3)")+
  ggtitle("molecules length per run")+   theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p3 <- ggplot(density_summary,aes(x=as.numeric(RunID),y=c1_den_median)) + geom_point(color="green")+
  geom_errorbar(aes(ymin=c1_den_q1,ymax=c1_den_q3),color="green")+xlab("run")+ylab("green label density (q1,median,q3)")+
  ggtitle("green label density per run")+   theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p4 <- ggplot(density_summary,aes(x=as.numeric(RunID),y=c2_den_median)) + geom_point(color="red")+ 
  geom_errorbar(aes(ymin=c2_den_q1,ymax=c2_den_q3),color="red")+xlab("run")+ylab("red label density (q1,median,q3)")+
  ggtitle("red label density per run")+  theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))
p5<- ggplot(density_summary,aes(x=as.numeric(RunID),y=yoyo_median)) + geom_point(color="blue")+
  geom_errorbar(aes(ymin=yoyo_q1,ymax=yoyo_q3),color="blue")+xlab("run")+ylab("yoyo average intensity in molecule \n (q1,median,q3 per scan)")+
  ggtitle("yoyo average intensity per run")+ theme(plot.title = element_text(size = 10),axis.title=element_text(size=8))


grid1<-plot_grid(p2, p5, p3, p4)
grid_suff<-"grid_plot"
grid_file_name<-paste(file_name,grid_suff,".png",sep="_")
save_plot(grid_file_name,grid1,base_aspect_ratio = 1.5)

p1
p1_suff<-"num_of_molecules"
p1_file_name<-paste(file_name,p1_suff,".png",sep="_")
save_plot(p1_file_name,p1,base_aspect_ratio = 1.5)