#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# R script rawdata output
library('ggplot2')
my_data=read.csv(args[1],header = F)
#my_data=read.csv('D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/rawdata.gc.m.csv',
#                 header = F)

colnames(my_data)=c('sample',"GC")
pdf(file=args[2],width = length(unique(my_data$sample))/2, height = 8)
#pdf(file = "D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/gc.pdf",   # The directory you want to save the file in
#    width = length(unique(my_data$sample))/2, 
#    height = 8)

ggplot(my_data, aes(x=sample, y=GC))+
  geom_boxplot(alpha=0.8,color="#e18139")+
  theme( axis.text=element_text(size=18,face="bold",color='black'), 
         axis.title=element_text(size=21,face="bold"),
         legend.position = "none",
         panel.background = element_rect(color = 'black', 
                                         fill = 'transparent'), 
         plot.title = element_text(hjust = 0.5),
         axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
         )+
  scale_y_continuous(limits=c(0, 100))+
  labs(x='',y="GC content %")
dev.off()

##36a583 #e18139 #7570b3
#
#


  