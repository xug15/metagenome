# metagenome
## Set the read data, and make links.
```sh
#1
ln -s /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/three/CleanData/m2/m2_1.fq.gz /public/home/2022122/xugang/project/zhouhongzhang/rawdata/m2_1.fq.gz
ln -s /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/three/CleanData/m2/m2_2.fq.gz /public/home/2022122/xugang/project/zhouhongzhang/rawdata/m2_2.fq.gz
#
ln -s /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/three/CleanData/mix1/mix1_1.fq.gz /public/home/2022122/xugang/project/zhouhongzhang/rawdata/mix1_1.fq.gz
ln -s /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/three/CleanData/mix1/mix1_2.fq.gz /public/home/2022122/xugang/project/zhouhongzhang/rawdata/mix1_2.fq.gz
#
ln -s /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/three/CleanData/mix2/mix2_1.fq.gz /public/home/2022122/xugang/project/zhouhongzhang/rawdata/mix2_1.fq.gz
ln -s /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/three/CleanData/mix2/mix2_2.fq.gz /public/home/2022122/xugang/project/zhouhongzhang/rawdata/mix2_2.fq.gz
#


#
 for i in `ls|grep X`;
 do 
 path=`pwd`
 echo $i;
    for j in `ls $i|grep fq|grep -v rmhost`;
    do echo ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    ln -s ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    done
 done
#
cd /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/OSS_DOWN/X101SC23102792-Z01-J002/01.RawData
 for i in `ls`;
 do 
 path=`pwd`
 echo $i;
    for j in `ls $i|grep fq|grep -v rmhost`;
    do echo ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    ln -s ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    done
 done
#
cd /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/X101SC23102792-Z01-J003/01.RawData
 for i in `ls`;
 do 
 path=`pwd`
 echo $i;
    for j in `ls $i|grep fq|grep -v rmhost`;
    do echo ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    ln -s ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    done
 done
 #
cd /public/home/2022122/xugang/project/zhouhongzhang/rawdata/legace/X101SC23102792-Z01-J004/01.RawData
 for i in `ls`;
 do 
 path=`pwd`
 echo $i;
    for j in `ls $i|grep fq|grep -v rmhost`;
    do echo ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    ln -s ${path}/$i/$j /public/home/2022122/xugang/project/zhouhongzhang/rawdata/$j
    done
 done
```
## 1. Set envrionment variable.
```sh
db=/public/home/2022122/xugang/project/maize_genome/maize_db2
db=/public/home/2022122/xugang/project/alfalfa_genome/alfalfa.zm1
datapath2=`pwd`/rawdata
output=`pwd`/output
adapt1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
adapt2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
thread=28
partnum=6
node=Fnode2
#node=Fnode1
#node=Cnode
node=Cnode2
#node=Gnode
#################
```

## MAG assembly
```sh
assemblyf_bd(){
date
file=a3-assembly
#[[ -d  $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}

for ((i=0; i<$partnum; i++));do
[[ -d  $output/${file}/part.$i ]] || mkdir -p  $output/${file}/part.$i
echo $i;
echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/part.$i/part.$i.%j.out
#SBATCH -e ${output}/${file}/part.$i/part.$i.%j.error
#SBATCH --partition=${node}
#SBATCH -J 3part.$i
#SBATCH -N 1
#SBATCH -n ${thread}

echo 'start bing assembly sequences.'
source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metaWRAP assembly -1 $output/a2-decontaminate/rmdu/part.$i.1.fastq -2  $output/a2-decontaminate/rmdu/part.$i.2.fastq -m 2000 -t ${thread} --megahit -o $output/${file}/part.$i
"> a3.assembly.${counter}.${name}.$i.sh
done
}



```

## binning the contig
```sh
binning(){
date
[[ -d  $output/a4-binning/${name} ]] || mkdir -p  $output/a4-binning/${name}


#echo -e "#!/bin/bash
#SBATCH -o ${output}/a4-binning/${name}/${name}.%j.out
#SBATCH -e ${output}/a4-binning/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J 4part.$i
#SBATCH -N 1
#SBATCH -n ${thread}
#echo start bing assembly sequences.

#source /public/home/2022122/xugang/bashrc
#conda run -n metawrap-env metaWRAP binning -l 200 -t ${thread}  --metabat2 --maxbin2 --concoct -a ${output}/a3-assembly/total/final_assembly.fasta -o $output/a4-binning/${name} ${output}/a2-decontaminate/clean_reads/*_1.fastq ${output}/a2-decontaminate/clean_reads/*_2.fastq" > a4.bin.${counter}.${name}.sh

for ((i=0; i<$partnum; i++));do
[[ -d  $output/a2-decontaminate/rmdu/part.$i ]] || mkdir -p  $output/a2-decontaminate/rmdu/part.$i
        for j in `cat $output/a2-decontaminate/rmdu/list.0*`;do
        #echo $j;
        namen="${j/fastq.unq.fq/fastq}"
        namen="${namen/rmdu/rmdu/part.${i}}"
        #echo $namen
        #echo "ln -s $j $namen"
        ln -s $j $namen
        done

done


for ((i=0; i<$partnum; i++));do
[[ -d  $output/a4-binning/part.$i ]] || mkdir -p  $output/a4-binning/part.$i


#echo $i;
echo -e "#!/bin/bash
#SBATCH -o ${output}/a4-binning/part.$i/part.$i.%j.out
#SBATCH -e ${output}/a4-binning/part.$i/part.$i.%j.error
#SBATCH --partition=${node}
#SBATCH -J 4part.$i
#SBATCH -N 1
#SBATCH -n ${thread}
echo start bing assembly sequences.

source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metaWRAP binning -l 200 -t ${thread}  --metabat2 --maxbin2 --concoct -a ${output}/a3-assembly/part.$i/final_assembly.fasta -o $output/a4-binning/part.$i ${output}/a2-decontaminate/rmdu/part.$i/*_1.fastq ${output}/a2-decontaminate/rmdu/part.$i/*_2.fastq
" > a4.bin.${counter}.${name}.$i.sh
done
}
```

## Using Kraken to annotation taxtion.
```sh
kraken2anno(){
date

file='a5-kraken2anno'

[[ -d  $output/a5-kraken2anno/${name} ]] || mkdir -p  $output/a5-kraken2anno/${name}
echo -e "#!/bin/bash
#SBATCH -o ${output}/a5-kraken2anno/${name}/${name}.%j.out
#SBATCH -e ${output}/a5-kraken2anno/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J 5${name}
#SBATCH -N 1
#SBATCH -n ${thread}

echo 'start kraken'
source /public/home/2022122/xugang/bashrc
/public/home/2022122/xugang/app/miniconda3/bin/conda run -n metawrap-env metawrap kraken2 -o  $output/a5-kraken2anno/${name} -t ${thread} -s 1000000 ${output}/a3-assembly/total/final_assembly.fasta ${output}/a2-decontaminate/clean_reads/*fastq

" > a5.kraken2.${counter}.${name}.sh

}

```

## binning refine.
```sh
bin_refine(){
date
file='a6-binrefine'
file6=$file
[[ -d  $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}


#echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J 6${name}
#SBATCH -N 1
#SBATCH -n ${thread}

#echo 'bin refine'
#source /public/home/2022122/xugang/bashrc
#conda run -n metawrap-env metawrap bin_refinement -o $output/${file}/${name} -t ${thread} -A $output/a4-binning/${name}/metabat2_bins/ -B $output/a4-binning/${name}/maxbin2_bins/ -C $output/a4-binning/${name}/concoct_bins/ -c 50 -x 10
# mv $output/a6-binrefine/${name}/metawrap_50_10_bins/binsO  $output/a6-binrefine/${name}
#" > a6.binrefine.${counter}.${name}.sh

for ((i=0; i<$partnum; i++));do
[[ -d  $output/a6-binrefine/part.$i ]] || mkdir -p  $output/a6-binrefine/part.$i
#echo $i;
echo -e "#!/bin/bash
#SBATCH -o ${output}/a6-binrefine/part.$i/part.$i.%j.out
#SBATCH -e ${output}/a6-binrefine/part.$i/part.$i.%j.error
#SBATCH --partition=${node}
#SBATCH -J 6part.$i
#SBATCH -N 1
#SBATCH -n ${thread}
echo start bing assembly sequences.

source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metawrap bin_refinement -o $output/a6-binrefine/part.$i -t ${thread} -A $output/a4-binning/part.$i/metabat2_bins/ -B $output/a4-binning/part.$i/maxbin2_bins/ -C $output/a4-binning/part.$i/concoct_bins/ -c 50 -x 10
" >a6.binrefine.${counter}.${name}.$i.sh
done
}
```

## merge assembly bin result.
```sh
merge_assembly_bin(){
rm $output/a3-assembly/total/merge.list
for ((i=0; i<$partnum; i++));do
echo "$output/a3-assembly/part.$i/final_assembly.fasta.clean.fa">>$output/a3-assembly/total/merge.list;
done
echo "#!/bin/bash
#SBATCH -o ${output}/a3-assembly/total/merge.%j.out
#SBATCH -e ${output}/a3-assembly/total/merge.%j.error
#SBATCH --partition=${node}
#SBATCH -J 2p${i}2
#SBATCH -N 1
#SBATCH -n ${thread}
echo date
">a7.merge.${counter}.sh
for ((i=0; i<$partnum; i++));do
echo "perl b8.rename.assemble.pl $output/a3-assembly/part.$i/final_assembly.fasta $i">>a7.merge.${counter}.sh
done
echo "xargs < $output/a3-assembly/total/merge.list cat > $output/a3-assembly/total/final_assembly.fasta
">>a7.merge.${counter}.sh

[[ -d $output/a4-binning/total/tmp ]] || mkdir -p $output/a4-binning/total/tmp
[[ -d $output/a6-binrefine/total/tmp/ ]] || mkdir -p $output/a6-binrefine/total/tmp/

[[ -d $output/a4-binning/total/concoct_bins ]] || mkdir -p $output/a4-binning/total/concoct_bins
[[ -d $output/a4-binning/total/maxbin2_bins ]] || mkdir -p $output/a4-binning/total/maxbin2_bins
[[ -d $output/a4-binning/total/metabat2_bins ]] || mkdir -p $output/a4-binning/total/metabat2_bins

echo "#!/bin/bash
#SBATCH -o $output/a4-binning/total/concocot.merge.%j.out
#SBATCH -e $output/a4-binning/total/concocot.merge.%j.error
#SBATCH --partition=${node}
#SBATCH -J 2p${i}2
#SBATCH -N 1
#SBATCH -n ${thread}
rm -rf $output/a4-binning/total/concoct_bins/*
rm -rf $output/a4-binning/total/maxbin2_bins/*
rm -rf $output/a4-binning/total/metabat2_bins/*
">a7.merge.bin.sh
for j in concoct_bins maxbin2_bins metabat2_bins;do 
for ((i=0; i<$partnum; i++));do
echo "rm -rf $output/a4-binning/total/tmp/*
cp -r $output/a4-binning/part.$i/$j/*fa $output/a4-binning/total/tmp
for i in \`ls $output/a4-binning/total/tmp|grep fa\`;do
name=\"\${i/bin/bin.$i}\";
mv  $output/a4-binning/total/tmp/\$i  $output/a4-binning/total/tmp/\$name
done
mv $output/a4-binning/total/tmp/*fa  $output/a4-binning/total/$j
">>a7.merge.bin.sh;
done
done
[[ -d $output/a6-binrefine/total/tmp ]] || mkdir -p $output/a6-binrefine/total/tmp
[[ -d $output/a6-binrefine/total/concoct_bins ]] || mkdir -p $output/a6-binrefine/total/concoct_bins
[[ -d $output/a6-binrefine/total/maxbin2_bins ]] || mkdir -p $output/a6-binrefine/total/maxbin2_bins
[[ -d $output/a6-binrefine/total/metabat2_bins ]] || mkdir -p $output/a6-binrefine/total/metabat2_bins
[[ -d $output/a6-binrefine/total/metawrap_50_10_bins ]] || mkdir -p $output/a6-binrefine/total/metawrap_50_10_bins
echo "#!/bin/bash
#SBATCH -o $output/a6-binrefine/total/concocot.merge.%j.out
#SBATCH -e $output/a6-binrefine/total/concocot.merge.%j.error
#SBATCH --partition=${node}
#SBATCH -J 2p${i}2
#SBATCH -N 1
#SBATCH -n ${thread}
rm -rf $output/a6-binrefine/total/concoct_bins/*
rm -rf $output/a6-binrefine/total/maxbin2_bins/*
rm -rf $output/a6-binrefine/total/metabat2_bins/*
rm -rf $output/a6-binrefine/total/metawrap_50_10_bins/*
">a7.merge.bin2.sh
for j in concoct_bins maxbin2_bins metabat2_bins metawrap_50_10_bins;do 
for ((i=0; i<$partnum; i++));do
echo "rm -rf $output/a6-binrefine/total/tmp/*
cp -r $output/a6-binrefine/part.$i/$j/*fa $output/a6-binrefine/total/tmp
for i in \`ls $output/a6-binrefine/total/tmp|grep fa\`;do
name=\"\${i/bin/bin.$i}\";
mv  $output/a6-binrefine/total/tmp/\$i  $output/a6-binrefine/total/tmp/\$name
done
mv $output/a6-binrefine/total/tmp/*fa  $output/a6-binrefine/total/$j
">>a7.merge.bin2.sh;
done
done
}
```

## visualize bloblogy result.
```sh
visualize_blobology(){
date
file='a7-blobology'
id=7
[[ -d  $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}
echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J ${id}${name}
#SBATCH -N 1
#SBATCH -n ${thread}

echo 'start blobology'
source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metawrap blobology -a ${output}/a3-assembly/total/final_assembly.fasta -t ${thread} -o $output/${file}/${name} --bins $output/a6-binrefine/total/metawrap_50_10_bins ${output}/a2-decontaminate/clean_reads/*fastq
" > a7.blobology.${counter}.${name}.sh
}

```

## Quantitative bin in different locations.
```sh
quant_bins_location(){
date
file='a9-quant_bins'
id=9
[[ -d  $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}
for ((i=0; i<$partnum; i++));do
[[ -d  $output/${file}/${name}/part.$i ]] || mkdir -p  $output/${file}/${name}/part.$i
echo $i;
echo "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J $i.quant
#SBATCH -N 1
#SBATCH -n ${thread}

source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metawrap quant_bins -a $output/a3-assembly/total/final_assembly.fasta -t $((thread*2)) -o $output/${file}/${name}/part.$i -b $output/a6-binrefine/${name}/metawrap_50_10_bins ${output}/a2-decontaminate/rmdu/part.$i/*fastq


"> a9.quant_bins.${counter}.${name}.$i.sh
done

}

```

## Classify bins.
```sh
classify_bins(){
file='ab-classify'
id=b

[[ -d  $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}

echo "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J $id${name}
#SBATCH -N 1
#SBATCH -n ${thread}

source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metawrap classify_bins -o $output/${file}/${name} -t ${thread} -b $output/a6-binrefine/${name}/metawrap_50_10_bins
"> ab.classify_bins.${counter}.${name}.sh

}
```

## Annotation bin with different location or groups.
```sh
annotation_bins_location(){
file='ac-bin-annotation'
id=c

[[ -d  $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}
[[ -d $output/a6-binrefine/${name}/metawrap_50_10_bins_name ]] || mkdir -p  $output/a6-binrefine/${name}/metawrap_50_10_bins_name

echo "">ac.prename_bins.${counter}.${name}.process.sh
for i in `ls $output/a6-binrefine/${name}/metawrap_50_10_bins|grep fa$`;
do 
echo "
perl `pwd`/b1.rename_assemble_name.pl $output/a6-binrefine/${name}/metawrap_50_10_bins/$i ${name}
mv $output/a6-binrefine/${name}/metawrap_50_10_bins/$i.clean.fa  $output/a6-binrefine/${name}/metawrap_50_10_bins_name/$i

">>ac.prename_bins.${counter}.${name}.process.sh

done

echo "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J $id${name}
#SBATCH -N 1
#SBATCH -n ${thread}

source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metawrap annotate_bins -o $output/${file}/${name} -t  ${thread} -b $output/a6-binrefine/${name}/metawrap_50_10_bins_name
"> ac.annotation_bins.${counter}.${name}.1gnode.sh


}
```

## Annotation contig location.
```sh
annotation_contigs_location(){
file='ad-contig-annotation'
id=dancontig

[[ -d $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}
[[ -d $output/a3-assembly/${name}/contig ]] || mkdir -p $output/a3-assembly/${name}/contig

echo "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J $id
#SBATCH -N 1
#SBATCH -n ${thread}
">ad.annotation_contigs.${counter}.${name}.sh

echo "
perl `pwd`/b9.rename.quntify.pl $output/a3-assembly/${name}/final_assembly.fasta ${name} 
rm -rf $output/a3-assembly/${name}/contig/*
#mv $output/a3-assembly/${name}/final_assembly.fasta.clean.fa  $output/a3-assembly/${name}/contig/final_assembly.fasta
cp -rf $output/a3-assembly/${name}/final_assembly.fasta.clean.fa  $output/a3-assembly/${name}/contig/
">> ad.annotation_contigs.${counter}.${name}.sh
numcpu=$((thread*2))
echo "
source /public/home/2022122/xugang/bashrc
conda run -n metawrap-env metawrap annotate_bins -o $output/${file}/${name} -t ${numcpu} -b $output/a3-assembly/${name}/contig
">> ad.annotation_contigs.${counter}.${name}.sh

}

```

## Calculate the MAG completeness and contamination.
```sh
check_completeness_contamination(){
date
[[ -d  $output/ae-completeness_contamination/${name} ]] || mkdir -p  $output/ae-completeness_contamination/${name}
if [ -d  "$output/a6-binrefine/${name}/metawrap_50_10_bins" ] ; then
echo "refine";
echo -e "#!/bin/bash
#SBATCH -o ${output}/ae-completeness_contamination/${name}/refine.${name}.%j.out
#SBATCH -e ${output}/ae-completeness_contamination/${name}/refine.${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J em50c10
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
rm -rf ${output}/ae-completeness_contamination/${name}/refine_bins/*
conda run -n metawrap-env checkm lineage_wf -t 56 $output/a6-binrefine/${name}/metawrap_50_10_bins ${output}/ae-completeness_contamination/${name}/refine_bins -x fa">ae.check.${counter}.${name}.0.sh
fi
if [ -d  "$output/a4-binning/${name}/concoct_bins" ] ; then
echo "cococt";
echo -e "#!/bin/bash
#SBATCH -o ${output}/ae-completeness_contamination/${name}/concoct.${name}.%j.out
#SBATCH -e ${output}/ae-completeness_contamination/${name}/concoct.${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J econcoct
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
rm -rf ${output}/ae-completeness_contamination/${name}/concoct_bins/*
conda run -n metawrap-env checkm lineage_wf -t 56 $output/a4-binning/${name}/concoct_bins ${output}/ae-completeness_contamination/${name}/concoct_bins -x fa">ae.check.${counter}.${name}.1.sh
fi
if [[ -d  "$output/a4-binning/${name}/metabat2_bins" ]] ; then
echo "metabat";
echo -e "#!/bin/bash
#SBATCH -o ${output}/ae-completeness_contamination/${name}/metabat2.${name}.%j.out
#SBATCH -e ${output}/ae-completeness_contamination/${name}/metabat2.${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J emetbat2
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
rm -rf ${output}/ae-completeness_contamination/${name}/metabat2_bins/*
conda run -n metawrap-env checkm lineage_wf -t 56 $output/a4-binning/${name}/metabat2_bins ${output}/ae-completeness_contamination/${name}/metabat2_bins -x fa">ae.check.${counter}.${name}.2.sh
fi
if [[ -d  "$output/a4-binning/${name}/maxbin2_bins" ]] ; then
echo "maxbin2_bins2";
echo -e "#!/bin/bash
#SBATCH -o ${output}/ae-completeness_contamination/${name}/maxbin2.${name}.%j.out
#SBATCH -e ${output}/ae-completeness_contamination/${name}/maxbin2.${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J emaxbin2
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
rm -rf ${output}/ae-completeness_contamination/${name}/maxbin2_bins/*
conda run -n metawrap-env checkm lineage_wf -t 56 $output/a4-binning/${name}/maxbin2_bins ${output}/ae-completeness_contamination/${name}/maxbin2_bins -x fa">ae.check.${counter}.${name}.3.sh
fi
}
```

## Extract completeness and contamination results.
```sh
check_completeness_contamination_formate(){
echo "">ae.2.formate.${name}.sh
[[ -d  $output/ae-completeness_contamination/summary ]] || mkdir -p  $output/ae-completeness_contamination/summary
for i in `ls ${output}/ae-completeness_contamination/${name}/|grep concoct.${name}|grep out`;do
if [ $(grep -c "Bin Id" ${output}/ae-completeness_contamination/${name}/$i) -eq 1 ];
then
echo "perl b2.formate.completeness.contamination.pl  ${output}/ae-completeness_contamination/${name}/$i
mv  ${output}/ae-completeness_contamination/${name}/*tsv $output/ae-completeness_contamination/summary
" >> ae.2.formate.${name}.sh
fi
done

for i in `ls ${output}/ae-completeness_contamination/${name}/|grep metabat2.${name}|grep out`;do
if [ $(grep -c "Bin Id" ${output}/ae-completeness_contamination/${name}/$i) -eq 1 ];
then
echo "perl b2.formate.completeness.contamination.pl  ${output}/ae-completeness_contamination/${name}/$i
mv  ${output}/ae-completeness_contamination/${name}/*tsv $output/ae-completeness_contamination/summary
" >> ae.2.formate.${name}.sh
fi
done

for i in `ls ${output}/ae-completeness_contamination/${name}/|grep refine.${name}|grep out`;do
if [ $(grep -c "Bin Id" ${output}/ae-completeness_contamination/${name}/$i) -eq 1 ];
then
echo "perl b2.formate.completeness.contamination.pl  ${output}/ae-completeness_contamination/${name}/$i
mv  ${output}/ae-completeness_contamination/${name}/*tsv $output/ae-completeness_contamination/summary
perl b3.length.fasta.pl $output/a6-binrefine/${name}/metawrap_50_10_bins refine.${name} $output/ae-completeness_contamination/summary

" >> ae.2.formate.${name}.sh
fi
done

}
```

## Annotation rRNA
```sh
searchrna(){
file='af-rna-structure-search'
id=f
[[ -d  $output/${file}/${name} ]] || mkdir -p  $output/${file}/${name}
echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J ${id}${name}
#SBATCH -N 1
#SBATCH -n ${thread}

">af.rna-structure.${counter}.${name}.sh

for j in `ls ${output}/a6-binrefine/${name}/metawrap_50_10_bins/|grep fa`;do echo -e "
conda run -n metawrap-env cmsearch --rfam --cut_ga --cpu ${thread} --nohmmonly --tblou ${output}/${file}/${name}/${i}.${j}.tblout -Z 1000 /public/home/2022122/xugang/database/rfam/Rfam.cm ${output}/a6-binrefine/${name}/metawrap_50_10_bins/${j} > ${output}/${file}/${name}/${name}.${j}
" >> af.rna-structure.${counter}.${name}.sh
done
echo -e "
touch $output/${file}/finish.${name}
">>af.rna-structure.${counter}.${name}.sh

if [[  ! -d ${output}/a6-binrefine/${name}/metawrap_50_10_bins  ]] ;then
rm af.rna-structure.${counter}.${name}.sh
fi
}
```
## Annotation tRNA.
```sh
searchtrna(){
echo "start search tRNA"
date
file='ag-trna-structure-search'
id=g

[[ -d ${output}/${file}/${name} ]] || mkdir -p ${output}/${file}/${name}

echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J ${id}${name}
#SBATCH -N 1
#SBATCH -n ${thread}
">ag.trna.${counter}.${name}.sh

for j in `ls ${output}/a6-binrefine/${name}/metawrap_50_10_bins/|grep fa`;do echo -e "
tRNAscan-SE -B -o ${output}/${file}/${name}/${j}.txt --thread ${thread} ${output}/a6-binrefine/${name}/metawrap_50_10_bins/${j}
">>ag.trna.${counter}.${name}.sh
done
echo -e "
touch $output/${file}/finish.${name}
">>ag.trna.${counter}.${name}.sh

}
```
## KO annotation.
```sh
koannotation(){
file='ah-koannotation'
[[ -d ${output}/ah-koannotation/${name} ]] || mkdir -p ${output}/ah-koannotation/${name}

echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J h${name}
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc

">ah.koann.${counter}.${name}.sh

for i in `ls ${output}/ac-bin-annotation/${name}/bin_translated_genes|grep faa$`;do
echo "
exec_annotation -o ${output}/af-koannotation/${name}/${name}.$i.querry2KO --cpu ${thread} --format mapper -E 1e-5 ${output}/ab-bin-annotation/${name}/bin_translated_genes/${i}
" >> ah.koann.${counter}.${name}.sh
done

echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J h${name}
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
exec_annotation -o ${output}/af-koannotation/${name}/${name}.contig.querry2KO --cpu ${thread} --format mapper -E 1e-5 ${output}/ad-contig-annotation/${name}/bin_translated_genes/final_assembly.fasta.clean.faa
">ah.koann.${counter}.${name}.contig.sh
}
```
## gtdb annotaiton classify.
```sh
gtdbkf(){
[[ -d ${output}/ag-gtdbtk/${name} ]] || mkdir -p ${output}/ag-gtdbtk/${name}
file='ag-gtdbtk'
rm ${output}/ag-gtdbtk/${name}/genome.txt
for i in `ls ${output}/a6-binrefine/total/metawrap_50_10_bins/|grep fa`;
do echo $i;
echo -e "${output}/a6-binrefine/total/metawrap_50_10_bins/$i\t$i">>${output}/ag-gtdbtk/${name}/genome.txt;
done

echo -e "#!/bin/bash
#SBATCH -o ${output}/${file}/${name}/${name}.%j.out
#SBATCH -e ${output}/${file}/${name}/${name}.%j.error
#SBATCH --partition=${node}
#SBATCH -J f${name}
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
#/public/home/2022122/xugang/database/mash_sketched_db
conda run -n gtdbtk-2.1.1 gtdbtk classify_wf --cpus ${thread} --batchfile ${output}/ag-gtdbtk/${name}/genome.txt --out_dir ${output}/ag-gtdbtk/${name} --mash_db /public/home/2022122/xugang/database/mash_sketched_db

">ag.gtdbkf.${counter}.${name}.contig.sh


}
```
## Using DRAM to annotation binning sequence gene and pathway.
```sh
dramf(){
[[ -d ${output}/ah-dram/${name}/bin ]] || mkdir -p ${output}/ah-dram/${name}/bin

for i in {1..9} ;
do
echo $i;
echo "#!/bin/bash
#SBATCH -o ${output}/ah-dram/${name}/bin/bin.%j.out
#SBATCH -e ${output}/ah-dram/${name}/bin/bin.%j.error
#SBATCH --partition=${node}
#SBATCH -J dreamdb
#SBATCH -N 1
#SBATCH -n 10
source /public/home/2022122/xugang/bashrc
conda run -n DRAM DRAM.py annotate -i '${output}/a6-binrefine/total/metawrap_50_10_bins/bin.$i*.fa' -o ${output}/ah-dram/${name}/bin/bin.$i --threads 56
">ah.dram.bin.$i.${counter}.${name}.bin.sh
done
}
```
## Uisng DRAM software to annotition gene.
```sh
dramfcontig(){
[[ -d ${output}/ah-dram/${name}/contig ]] || mkdir -p ${output}/ah-dram/${name}/contig
cp ${output}/a3-assembly/total/final_assembly.fasta ${output}/ah-dram/${name}/contig
perl b7.split.fa.pl ${output}/ah-dram/${name}/contig/final_assembly.fasta
rm ${output}/ah-dram/${name}/contig/final_assembly.fasta
prefix=0
for i in `ls ${output}/ah-dram/${name}/contig/|grep fasta`;
do echo $i;
echo $prefix;
((prefix++))
echo "#!/bin/bash
#SBATCH -o ${output}/ah-dram/${name}/contig/bin.%j.out
#SBATCH -e ${output}/ah-dram/${name}/contig/bin.%j.error
#SBATCH --partition=${node}
#SBATCH -J dreamdb
#SBATCH -N 1
#SBATCH -n 10
source /public/home/2022122/xugang/bashrc
conda run -n DRAM DRAM.py annotate -i ${output}/ah-dram/${name}/contig/$i -o ${output}/ah-dram/${name}/contig/contig.${prefix} --threads ${thread}
">ah.dram.contig.${prefix}.${counter}.${name}.sh
done
}
```
## Extract dram annotation pathway.
```sh
mergedram(){
[[ -d ${output}/ah-dram/${name}/summary/bin ]] || mkdir -p ${output}/ah-dram/${name}/summary/bin
[[ -d ${output}/ah-dram/${name}/summary/contig ]] || mkdir -p ${output}/ah-dram/${name}/summary/contig
rm ah.dram.merge.bin.sh
for i in {1..9} ;
do
echo $i;
echo "cp ${output}/ah-dram/${name}/bin/bin.$i/annotations.tsv ${output}/ah-dram/${name}/summary/bin/annotation.bin.$i.tsv
">>ah.dram.merge.bin.sh
done
}
```

##
```sh
counter=0
for i in `ls -tr ${datapath2}|grep R1`;do
date
        input2="${i/R1/R2}";
        input1=$i
        name="${i/.R1.fastq.gz/}";
echo $name
#        IFS='--' read -r -a name2 <<< "$name";
#        name=${name2[2]}
#        echo $name
        ((counter++))
#prepare_fastq
#rmdup_sample
done
name='total'
((counter++))
#merge_fq
#rmdup
#assemblyf_bd
#binning
#kraken2anno
#bin_refine
#merge_assembly_bin
#visualize_blobology
#quant_bins_location
#reassemblef
#classify_bins
#annotation_bins_location
annotation_contigs_location
#check_completeness_contamination
#check_completeness_contamination_formate
#searchrna
#searchtrna
#koannotation
#gtdbkf
#dramf
#dramfcontig
#mergedram

```


