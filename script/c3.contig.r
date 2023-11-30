#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# R script rawdata output
library('ggplot2')
library(scales)
my_data=read.table(args[1],header = F,sep="\t")
#my_data=read.table('D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/out.txt',sep="\t",
#                header = F)
#head(my_data)
colnames(my_data)=c("id",'length',"coverage")
pdf(file=paste0(args[2],"/contig.length.pdf"),width = 14, height = 8)
#pdf(file = "D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/gc.pdf",   # The directory you want to save the file in
#    width = length(unique(my_data$sample))/2, 
#    height = 8)

ggplot(my_data, aes(x=length) )+
  geom_histogram(fill="#35a582",color="#595959",)+
  theme( axis.text=element_text(size=18,face="bold",color='black'), 
         axis.title=element_text(size=21,face="bold"),
         legend.position = "none",
         panel.background = element_rect(color = 'black', 
                                         fill = 'transparent'), 
         plot.title = element_text(hjust = 0.5)
  )+
  labs(x='Contig Length(bp)',y="Number of Contigs")+ 
  scale_y_continuous(labels = scales::comma)+
  scale_x_continuous(labels = scales::comma)
dev.off()
pdf(file=paste0(args[2],"/contig.1000.length.pdf"),width = 14, height = 8)
ggplot(my_data[1:1000,], aes(x=length) )+
  geom_histogram(fill="#35a582",color="#595959")+
  theme( axis.text=element_text(size=18,face="bold",color='black'), 
         axis.title=element_text(size=21,face="bold"),
         legend.position = "none",
         panel.background = element_rect(color = 'black', 
                                         fill = 'transparent'), 
         plot.title = element_text(hjust = 0.5)
  )+
  labs(x='Contig Length(bp)',y="Number of Contigs","The larget 1000 contigs")+ 
  scale_y_continuous(labels = scales::comma)+
  scale_x_continuous(labels = scales::comma)
dev.off()

pdf(file=paste0(args[2],"/contig.coverage.1000.length.pdf"),width = 14, height = 8)
ggplot(my_data[1:1000,],aes(x=length,y=coverage) )+
  geom_point(color="#00bfc4")+
  theme( axis.text=element_text(size=18,face="bold",color='black'), 
         axis.title=element_text(size=21,face="bold"),
         legend.position = "none",
         panel.background = element_rect(color = 'black', 
                                         fill = 'transparent'), 
         plot.title = element_text(hjust = 0.5))+
           labs(x='Contig Length(bp)',y="Coverage",title="Largest 1000 contigs")+
           scale_y_continuous(labels = scales::comma)+
           scale_x_continuous(labels = scales::comma)+
           geom_density_2d()
dev.off()
