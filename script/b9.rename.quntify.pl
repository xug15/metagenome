open I, "<$ARGV[0]";
open O, ">$ARGV[0].clean.fa";

$id=0;
while(<I>){
chomp;
if($_=~/^>(.*?)$/){
    $id++;
#@data=split /_/,$_;
if(exists($ARGV[1])){
print O ">$ARGV[1]_$id\n";
}else{

print O "$data[0]_$di\n";
}



}else{
print O "$_\n";
}

}
close O;
close I;

