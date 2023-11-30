#install.packages("readxl")
#library("readxl")
library('ggplot2')
#library('dplyr')
library(RColorBrewer)
# xls files
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# R script rawdata output
library('ggplot2')
completeness=read.table(args[1],header=T)
binlength <- read.table(args[2],header=T)
#completeness <- read.table("D:/a-document/sequencing_center_desktop/yanglab/中农教务/王媛/data/completeness_length/refine.total.tsv",header=T)
#binlength <- read.table("D:/a-document/sequencing_center_desktop/yanglab/中农教务/王媛/data/completeness_length/refine.total.length.tsv",header=T)
head(completeness)
head(binlength)

completne_length=merge(completeness, binlength, by = "BinId")
completne_length$group="1%-50% complete"
completne_length$group[completne_length$Completeness>90 & completne_length$Completeness<100]="90%-100% complete"
completne_length$group[completne_length$Completeness>80 & completne_length$Completeness<90]="80%-90% complete"
completne_length$group[completne_length$Completeness>50 & completne_length$Completeness<80]="50%-80% complete"
completne_length$lengthkb=completne_length$Length/1000
#
head(completne_length)
#
pdf(file=paste0(args[4],"/",args[3],".bincomplete.len.pdf"),width = 16, height = 8)
ggplot(completne_length, aes(y=group, x=lengthkb, fill=group))+
  geom_violin(alpha=0.8)+
  geom_point(aes(fill = group), size = 2, shape = 21, position = position_jitterdodge()) +
  theme( axis.text=element_text(size=20,face="bold",color='black'), 
         axis.title=element_text(size=21,face="bold"),
         legend.position = "none",
         panel.background = element_rect(color = 'black', 
                                         fill = 'transparent'), 
         plot.title = element_text(hjust = 0.5))+
  scale_fill_brewer(palette="Dark2")+
  labs(y='',x="Length\n(Kb)",title=args[3])
dev.off()

