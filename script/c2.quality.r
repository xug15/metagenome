#######################################################
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# R script rawdata output
library('ggplot2')
my_data=read.csv(args[1],header = F)

#my_data=read.csv('D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/rawdata.quality.m.csv',
#                 header = F)
colnames(my_data)=c('sample',"GC")
head(my_data)  
pdf(file=args[2],width = length(unique(my_data$sample))/2, height = 8)
#pdf(file = "D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/quality.pdf",   # The directory you want to save the file in
#    width = length(unique(my_data$sample))/2, 
#    height = 8)
ggplot(my_data, aes(x=sample, y=GC))+
  geom_boxplot(alpha=0.8,color="#36a583")+
  theme( axis.text=element_text(size=18,face="bold",color='black'), 
         axis.title=element_text(size=21,face="bold"),
         legend.position = "none",
         panel.background = element_rect(color = 'black', 
                                         fill = 'transparent'), 
         plot.title = element_text(hjust = 0.5),
         axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
  )+
  scale_y_continuous(limits=c(0, 50),breaks = seq(0, 50, 10))+
  labs(x='',y="Quality",title=args[3])
dev.off()