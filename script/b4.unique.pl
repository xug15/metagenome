#!/user/bin/perl
open I1, "<$ARGV[0]";#fq1
open I2, "<$ARGV[1]";#fq2
open O1, ">$ARGV[0].unq.fq";
open O2, ">$ARGV[1].unq.fq";
$title=$ARGV[2];
%seq1;
$seq2;
while(<I2>){
$name2=$_;
<I1>;
$seq2=<I2>;
$seq1=<I1>;
<I2>;
<I1>;
$qua1=<I1>;
$qua2=<I2>;
$seq1{$seq1."\t".$seq2}=$qua1."\t".$qua2;
}
close I1;
close I2;
$num=1;
foreach(keys(%seq1)){
@seq=split "\t",$_;
$qua=$seq1{$_};
@qua=split "\t",$qua;
print O1 "\@$title$num 1\n$seq[0]+\n$qua[0]";
print O2 "\@$title$num 2\n$seq[1]+\n$qua[1]";
$num++;
}


