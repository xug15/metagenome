
open I, "<$ARGV[0]";
#print $filename."/".$file."\n";
my %singleLineSequences;
my $sequence_id;
$n=0;
while(<I>){
chomp;
    if ($_ =~ /^(>.*)$/){
        $sequence_id = $1; # e.g., YKR054C
        $singleLineSequences{$sequence_id} = "";
        $n++;
        }
    else {
        $singleLineSequences{$sequence_id} = $singleLineSequences{$sequence_id} . $_;
        }

}

close I;

$part=$n/50;
$part=int($part);
print "$n\t$part\n";
$count=0;
$prefix=1;
my $total_length=0;
foreach my $sequence_entry (keys %singleLineSequences){
    if($count%$part==0){
        close O;
        open O, ">$ARGV[0].$prefix.fa";
        $prefix++;
    }
    $count++;
print O "$sequence_entry\n";
print O "$singleLineSequences{$sequence_entry}\n";

}
close O;
