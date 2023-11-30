
open I, "<$ARGV[0]";
open O1, ">$ARGV[1]";
open O2, ">$ARGV[1].statis.txt";
my @number;
my @number2;
$total=0;
$n=1;
while(<I>){
chomp;
if($_=~/>/){
$_=~/length_(.*?)_cov_(.*?)$/;
#print "$_\n";
print O1 "$n\t$1\t$2\n";
$length=$1;
$cov=$2;
    if($length>=500)
    {
    push @number, $length;
    }
    $n++;
    $total=$length+$total;
}

}
close I;
close O;

@number=sort{$b <=> $a} @number;
$i1=int(0.1*$total);
$i2=int(0.2*$total);
$i3=int(0.3*$total);
$i4=int(0.4*$total);
$i5=int(0.5*$total);
$i6=int(0.6*$total);
$i75=int(0.75*$total);
$i9=int(0.9*$total);
$acco=0;
$con=0;
print O2 "N10\tL10\tN50\tL50\tN60\tL60\tN75\tL75\tN90\tL90\n";
foreach(@number){
$acco=$acco+$_;
$con++;
if($acco>=$i1){
print O2 "$_\t";
print O2 "$con\t";
last;
}
}
$acco=0;
foreach(@number){
$acco=$acco+$_;
$con++;
if($acco>=$i5){
print O2 "$_\t";
print O2 "$con\t";
last;
}
}
$acco=0;
foreach(@number){
$acco=$acco+$_;
$con++;
if($acco>=$i6){
print O2 "$_\t";
print O2 "$con\t";
last;
}
}
$acco=0;
foreach(@number){
$acco=$acco+$_;
$con++;
if($acco>=$i75){
print O2 "$_\t";
print O2 "$con\t";
last;
}
}
$acco=0;
foreach(@number){
$acco=$acco+$_;
$con++;
if($acco>=$i9){
print O2 "$_\t";
print O2 "$con\n";
last;
}
}


