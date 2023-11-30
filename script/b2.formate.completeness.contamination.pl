#!/bin/perl
open I, "<$ARGV[0]";
#open I, "<concoct.test.354510.out";

@outname=split/\./,$ARGV[0];
$outname=$outname[0].".".$outname[1];
open O, ">$outname.tsv";
print O "BinId\tMarkerlineage\tgenomes\tmarkers\tmarkersets\tCompleteness\tContamination\tStrainHeterogeneity\n";
#open O, "";
while(<I>){
chomp;
if($_=~/^--/){

}elsif($_=~/ Bin Id/){

}
else{
#print "$_\n";
@data=split/\s+/,$_;
#print "@data\n";
#print "0$data[0]\t1$data[1]\t2$data[2]\t3$data[3]\t4$data[4]\t5$data[5]\t6$data[6]\t7$data[7]\t8$data[8]\t9$data[9]\t10$data[10]\t11$data[11]\t12$data[12]\t13$data[13]\t14$data[14]\t15$data[15]\n";
print O "$data[1]\t$data[2].$data[3]\t$data[4]\t$data[5]\t$data[6]\t$data[13]\t$data[14]\t$data[15]\n";
}

}
close I;
close O;








