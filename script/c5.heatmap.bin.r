args = commandArgs(trailingOnly=TRUE)
# R script rawdata output

library('dplyr')
library(pheatmap)

#my_data=read.table('D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/bin_abundance_table.tab', 
#                   header = T,sep="\t")
my_data=read.table(args[1],header = T,sep="\t")
rownames(my_data)=my_data$Genomic.bins
head(my_data)

binmatrix=my_data[,-1]
len1=dim(binmatrix)[1]
len2=dim(binmatrix)[2]

ratio=len1/len2

hv=16*ratio


pdf(file=paste0(args[3],"/heatmap.",args[2],".byspecies.pdf"),width = 16, height = hv)
pheatmap(binmatrix, 
         cluster_cols = T, 
         scale='row', 
         cluster_rows = T)

dim(binmatrix)
dev.off()


pdf(file=paste0(args[3],"/heatmap.",args[2],".bysample.pdf"),width = 16, height = hv)
pheatmap(binmatrix, 
         cluster_cols = T, 
         scale='column', 
         cluster_rows = T)

dev.off()






