library(stringr)
str_match(alice, ".*\\.D([0-9]+)\\.LIS.*")[, 2]

#read files
files=list.files(path="D:/a-document/sequencing_center_desktop/yanglab/project/pipeline/fastqc/", pattern=".quant.counts", all.files=TRUE,
           full.names=TRUE)

print(files[1])

###########################
#load data.
my_data1=read.table(files[1], 
                    header = T,sep="\t")
#extract file name, and sample name.
samplen=str_match(files[1],"fastqc/(.*).quant.counts$")[,2]
#rename the table.
colnames(my_data1)=c('id',samplen)

############################
for(i in seq(2,length(files),by=1)){
  print(i)
  print(files[i])
  ##########################################
  #load data2.
  my_data2=read.table(files[i], 
                      header = T,sep="\t")
  #extract file name, and sample name.
  samplen=str_match(files[i],"fastqc/(.*).quant.counts$")[,2]
  #rename the table.
  colnames(my_data2)=c('id',samplen)
  head(my_data2)
  ##########################################
  #merge files
  merge_data=merge(my_data1,my_data2,by="id")
  head(merge_data)
  my_data1=merge_data
  
  
}

head(my_data1)





