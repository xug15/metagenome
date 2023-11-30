db=/public/home/2022122/xugang/project/maize_genome/maize_db2
db=/public/home/2022122/xugang/project/alfalfa_genome/alfalfa.zm1
datapath2=`pwd`/rawdata
output=`pwd`/output
adapt1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
adapt2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
thread=14
#node=Fnode2
#node=Fnode1
node=Cnode
#################






fastqcf(){
[[ -d $output/summary/a1-raw ]] || mkdir -p $output/summary/a1-raw
[[ -d $output/summary/a2-rmad ]] || mkdir -p $output/summary/a2-rmad
[[ -d $output/summary/a3-decom ]] || mkdir -p $output/summary/a3-decom
echo -e "#!/bin/bash
#SBATCH -o ${output}/summary/a1-raw/${name}.qcqr.%j.out
#SBATCH -e ${output}/summary/a1-raw/${name}.qcqr.%j.error
#SBATCH --partition=${node}
#SBATCH -J q1${name}
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
fastqc -t ${thread} ${datapath2}/${input1} ${datapath2}/${input2} -o ${output}/summary/a1-raw
" > aq1raw.${counter}.${name}.sh


echo -e "#!/bin/bash
#SBATCH -o ${output}/summary/a2-rmad/${name}.qcrm.%j.out
#SBATCH -e ${output}/summary/a2-rmad/${name}.qcrm.%j.error
#SBATCH --partition=${node}
#SBATCH -J q2${name}
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
fastqc -t ${thread}  ${output}/a1-cleandata/${name}/$name.1.fq.gz  ${output}/a1-cleandata/${name}/$name.2.fq.gz -o ${output}/summary/a2-rmad

" > aq2.${counter}.${name}.sh

echo -e "#!/bin/bash
#SBATCH -o ${output}/summary/a3-decom/${name}.qcde.%j.out
#SBATCH -e ${output}/summary/a3-decom/${name}.qcde.%j.error
#SBATCH --partition=${node}
#SBATCH -J q3${name}
#SBATCH -N 1
#SBATCH -n ${thread}
source /public/home/2022122/xugang/bashrc
fastqc -t ${thread} ${output}/a2-decontaminate/${name}/$name.dec*.fq.gz  ${output}/a2-decontaminate/${name}/$name.pe*.fq.gz -o ${output}/summary/a3-decom
" > aq3.${counter}.${name}.sh

}
fastqcmerge(){
[[ -d $output/summary/a1-raw/html ]] || mkdir -p $output/summary/a1-raw/html
[[ -d $output/summary/a2-rmad/html ]] || mkdir -p $output/summary/a2-rmad/html
[[ -d $output/summary/a3-decom/html ]] || mkdir -p $output/summary/a3-decom/html

mv $output/summary/a1-raw/*.html $output/summary/a1-raw/html/
mv $output/summary/a2-rmad/*.html $output/summary/a2-rmad/html/
mv $output/summary/a3-decom/*.html $output/summary/a3-decom/html/

inputn1="${input1/.fastq.gz/_fastqc.zip}"
inputn2="${input2/.fastq.gz/_fastqc.zip}"

inputnt1="${input1/.fastq.gz/_fastqc}"
inputnt2="${input2/.fastq.gz/_fastqc}"

echo "#!/bin/bash
#SBATCH -o ${output}/summary/a3-decom/${name}.qcde.%j.out
#SBATCH -e ${output}/summary/a3-decom/${name}.qcde.%j.error
#SBATCH --partition=${node}
#SBATCH -J q3${name}
#SBATCH -N 1
#SBATCH -n ${thread}
#source /public/home/2022122/xugang/bashrc

mv ${output}/summary/a1-raw/${inputn1} ${output}/summary/a1-raw/${name}.1_fastqc.zip
mv ${output}/summary/a1-raw/${inputn2} ${output}/summary/a1-raw/${name}.2_fastqc.zip

cd ${output}/summary/a1-raw
unzip -o ${output}/summary/a1-raw/${name}.1_fastqc.zip
unzip -o ${output}/summary/a1-raw/${name}.2_fastqc.zip
mv ${output}/summary/a1-raw/${inputnt1} ${output}/summary/a1-raw/${name}.1_fastqc
mv ${output}/summary/a1-raw/${inputnt2} ${output}/summary/a1-raw/${name}.2_fastqc

cd ${output}/summary/a2-rmad
unzip -o ${output}/summary/a2-rmad/$name.1_fastqc.zip
unzip -o ${output}/summary/a2-rmad/$name.2_fastqc.zip

cd ${output}/summary/a3-decom
unzip -o ${output}/summary/a3-decom/$name.pe.dec1_fastqc.zip
unzip -o ${output}/summary/a3-decom/$name.pe.dec2_fastqc.zip
unzip -o ${output}/summary/a3-decom/$name.dec1_fastqc.zip
unzip -o ${output}/summary/a3-decom/$name.dec2_fastqc.zip
">auzip.${counter}.${name}.sh
}


extract_quality(){
echo "#!/bin/bash
#SBATCH -o ${output}/summary/a3-decom/${name}.qcde.%j.out
#SBATCH -e ${output}/summary/a3-decom/${name}.qcde.%j.error
#SBATCH --partition=${node}
#SBATCH -J q3${name}
#SBATCH -N 1
#SBATCH -n ${thread}
#source /public/home/2022122/xugang/bashrc

perl b5.fastqc.formate.pl ${output}/summary/a1-raw/${name}.1_fastqc/fastqc_data.txt ${name} ${output}/summary/a1-raw/${name}.1_fastqc/
perl b5.fastqc.formate.pl ${output}/summary/a1-raw/${name}.2_fastqc/fastqc_data.txt ${name} ${output}/summary/a1-raw/${name}.2_fastqc/
perl b5.fastqc.formate.pl ${output}/summary/a2-rmad/$name.1_fastqc/fastqc_data.txt ${name} ${output}/summary/a2-rmad/$name.1_fastqc/
perl b5.fastqc.formate.pl ${output}/summary/a2-rmad/$name.2_fastqc/fastqc_data.txt ${name} ${output}/summary/a2-rmad/$name.2_fastqc/
perl b5.fastqc.formate.pl ${output}/summary/a3-decom/$name.pe.dec1_fastqc/fastqc_data.txt ${name} ${output}/summary/a3-decom/$name.pe.dec1_fastqc/
perl b5.fastqc.formate.pl ${output}/summary/a3-decom/$name.pe.dec2_fastqc/fastqc_data.txt ${name} ${output}/summary/a3-decom/$name.pe.dec2_fastqc/
perl b5.fastqc.formate.pl ${output}/summary/a3-decom/$name.dec1_fastqc/fastqc_data.txt ${name} ${output}/summary/a3-decom/$name.dec1_fastqc/
perl b5.fastqc.formate.pl ${output}/summary/a3-decom/$name.dec2_fastqc/fastqc_data.txt ${name} ${output}/summary/a3-decom/$name.dec2_fastqc/
#merge result
cat ${output}/summary/a1-raw/${name}.1_fastqc/${name}.gc.csv ${output}/summary/a1-raw/${name}.2_fastqc/${name}.gc.csv >${output}/summary/a1-raw/${name}.gc.csv
cat ${output}/summary/a1-raw/${name}.1_fastqc/${name}.quality.csv ${output}/summary/a1-raw/${name}.2_fastqc/${name}.quality.csv >${output}/summary/a1-raw/${name}.quality.csv
cat ${output}/summary/a2-rmad/$name.1_fastqc/${name}.gc.csv ${output}/summary/a2-rmad/$name.2_fastqc/${name}.gc.csv > ${output}/summary/a2-rmad/${name}.gc.csv
cat ${output}/summary/a2-rmad/$name.1_fastqc/${name}.quality.csv ${output}/summary/a2-rmad/$name.2_fastqc/${name}.quality.csv> ${output}/summary/a2-rmad/${name}.quality.csv
cat ${output}/summary/a3-decom/$name.pe.dec1_fastqc/${name}.gc.csv  ${output}/summary/a3-decom/$name.pe.dec2_fastqc/${name}.gc.csv >  ${output}/summary/a3-decom/${name}.pe.gc.csv
cat ${output}/summary/a3-decom/$name.pe.dec1_fastqc/${name}.quality.csv  ${output}/summary/a3-decom/$name.pe.dec2_fastqc/${name}.quality.csv >  ${output}/summary/a3-decom/${name}.pe.quality.csv
cat ${output}/summary/a3-decom/$name.dec2_fastqc/${name}.gc.csv ${output}/summary/a3-decom/$name.dec1_fastqc/${name}.gc.csv >${output}/summary/a3-decom/${name}.dec.gc.csv
cat ${output}/summary/a3-decom/$name.dec2_fastqc/${name}.quality.csv ${output}/summary/a3-decom/$name.dec1_fastqc/${name}.quality.csv > ${output}/summary/a3-decom/${name}.dec.quality.csv

">aex.${counter}.${name}.sh



}

mergefq(){
echo "
cat ${output}/summary/a1-raw/*gc.csv > ${output}/summary/a1-raw/rawdata.gc.m.csv
cat ${output}/summary/a1-raw/*.quality.csv > ${output}/summary/a1-raw/rawdata.quality.m.csv
cat ${output}/summary/a2-rmad/*gc.csv > ${output}/summary/a2-rmad/rmad.gc.m.csv
cat ${output}/summary/a2-rmad/*.quality.csv > ${output}/summary/a2-rmad/rmad.quality.m.csv
cat ${output}/summary/a3-decom/*.pe.gc.csv > ${output}/summary/a3-decom/out.pe.gc.m.csv
cat ${output}/summary/a3-decom/*.pe.quality.csv > ${output}/summary/a3-decom/out.quality.m.csv
cat ${output}/summary/a3-decom/*.dec.gc.csv > ${output}/summary/a3-decom/uncom.gc.m.csv
cat ${output}/summary/a3-decom/*.dec.quality.csv > ${output}/summary/a3-decom/uncom.quality.m.csv
">aex.${counter}.${name}.sh


}

plotfq(){
[[ -d $output/summary/b1-report ]] || mkdir -p $output/summary/b1-report   
echo "
source /public/home/2022122/xugang/bashrc
Rscript c1.gc.r ${output}/summary/a1-raw/rawdata.gc.m.csv $output/summary/b1-report/raw.gc.pdf 'Raw data'
Rscript c1.gc.r ${output}/summary/a2-rmad/rmad.gc.m.csv $output/summary/b1-report/rmad.gc.pdf 'Remove adapter'
Rscript c1.gc.r ${output}/summary/a3-decom/out.pe.gc.m.csv $output/summary/b1-report/final.gc.pdf 'Final assembly reads'
Rscript c1.gc.r ${output}/summary/a3-decom/uncom.gc.m.csv $output/summary/b1-report/rmcon.gc.pdf 'Remove host sequence'
#
Rscript c2.quality.r ${output}/summary/a1-raw/rawdata.quality.m.csv $output/summary/b1-report/raw.quality.pdf 'Raw data'
Rscript c2.quality.r ${output}/summary/a2-rmad/rmad.quality.m.csv $output/summary/b1-report/rmad.quality.pdf 'Remove adapter'
Rscript c2.quality.r ${output}/summary/a3-decom/out.quality.m.csv $output/summary/b1-report/final.quality.pdf 'Final assembly reads'
Rscript c2.quality.r ${output}/summary/a3-decom/uncom.quality.m.csv $output/summary/b1-report/rmcon.quality.pdf 'Remove host sequence'

">aplot.${counter}.${name}.sh 

}

contigquality(){
[[ -d ${output}/summary/a4-contig  ]] || mkdir -p ${output}/summary/a4-contig 
echo "
perl b6.contig.statistc.pl ${output}/a3-assembly/total/final_assembly.fasta ${output}/summary/a4-contig/contig.txt
source /public/home/2022122/xugang/bashrc
Rscript c3.contig.r ${output}/summary/a4-contig/contig.txt ${output}/summary/b1-report
">acontig.${counter}.${name}.sh
}

binplot(){
echo "
source /public/home/2022122/xugang/bashrc
Rscript c4.bin.r ${output}/ae-completeness_contamination/summary/refine.total.tsv ${output}/ae-completeness_contamination/summary/refine.total.length.tsv 'Refine' ${output}/summary/b1-report
Rscript c4.bin.r ${output}/ae-completeness_contamination/summary/concoct.total.tsv ${output}/ae-completeness_contamination/summary/concoct.total.length.tsv 'Concoct' ${output}/summary/b1-report
Rscript c4.bin.r ${output}/ae-completeness_contamination/summary/maxbin2.total.tsv ${output}/ae-completeness_contamination/summary/maxbin2_bins.total.length.tsv 'Maxbin2' ${output}/summary/b1-report
Rscript c4.bin.r ${output}/ae-completeness_contamination/summary/metabat2.total.tsv ${output}/ae-completeness_contamination/summary/metabat2.total.length.tsv 'Metabat2' ${output}/summary/b1-report


">abin.plot.${counter}.${name}.sh 
}
heatmapplot(){
echo "
source /public/home/2022122/xugang/bashrc
Rscript c5.heatmap.bin.r ${output}/a8-quant_bins/total/bin_abundance_table.tab 'total' ${output}/summary/b1-report

">aheat.plot.${counter}.${name}.sh 

}
#runone
counter=0

#for i in `ls -tr ${datapath2}`;do
for i in `ls -tr ${datapath2}|grep R1.fastq.gz$`;do
date
        input2="${i/R1/R2}";
        input1=$i
        name="${i/.R1.fastq.gz/}";
        #IFS='--' read -r -a name2 <<< "$name";
        #name=${name2[2]}
        echo $name
        ((counter++))

fastqcf
#fastqcmerge
#extract_quality
done
#mergefq
#plotfq
#contigquality
#binplot
#heatmapplot

