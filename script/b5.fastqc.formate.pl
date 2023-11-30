#!/usr/bin/perl
open I, "<$ARGV[0]";
$path=$ARGV[2];
open O1, ">$ARGV[2]/$ARGV[1].quality.csv";
open O2, ">$ARGV[2]/$ARGV[1].gc.csv";
$name=$ARGV[1];
$quality=0;


while(<I>){
chomp;


if($_=~/>>END_MODULE/){
$quality=0;
}
if($_=~/>>Per base sequence quality/){
<I>;
$_=<I>;
chomp;
$quality=1;
}

if($_=~/>>Per base sequence conten/){
<I>;
$_=<I>;
chomp;
$quality=2;
}

#read quality
if($quality==1){
#print "1$_\n";
@data=split /\s+/,$_;
print O1 "$name,$data[1]\n";
}
#gc content
if($quality==2){
#print "2$_\n";
@data=split /\s+/,$_;
$gc=$data[1]+$data[4];
print O2 "$name,$gc\n";
}

}

close I;
close O1;
close O2;

