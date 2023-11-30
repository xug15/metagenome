open I, "<$ARGV[0]";
open O, ">$ARGV[0].clean.fa";


while(<I>){
chomp;
if($_=~/^>(.*?)$/){
#@data=split /_/,$_;
if(exists($ARGV[1])){
print O ">$ARGV[1]_$1\n";
}else{

print O "$data[0]_$1\n";
}



}else{
print O "$_\n";
}

}
close O;
close I;



