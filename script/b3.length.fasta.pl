$filename=$ARGV[0];
#print "$ARGV[2]/$ARGV[1].length.tsv\n";
open O, ">$ARGV[2]/$ARGV[1].length.tsv";

print O "BinId\tLength\n";
opendir(DIR,$filename) or die "can not open directory:$I";
while(defined( $file=readdir(DIR) )){

#print "$filename\/$file\n";
@name=split/\./,$file;
$name1=$name[0].".".$name[1];
#print "$name1\n";
############
if($file=~/fa/){


open FASTA, "<$filename"."/"."$file";
#print $filename."/".$file."\n";
my %singleLineSequences;
my $sequence_id;
while(<FASTA>){
#print "$_";
    my $line = $_;
    chomp($line);
    if ($line =~ m/^>(\S+)/){
        $sequence_id = $1; # e.g., YKR054C
        $singleLineSequences{$sequence_id} = "";
        }
    else {
        $singleLineSequences{$sequence_id} = $singleLineSequences{$sequence_id} . $line;
        }

}

my $total_length=0;
foreach my $sequence_entry (keys %singleLineSequences){
    my $currentSequence = $singleLineSequences{$sequence_entry};

    my $lengthSequence = length($currentSequence);

#print $sequence_entry . "," . $lengthSequence . "\n";
$total_length=$total_length+$lengthSequence;
}

#print "$name1\t$total_length\n";
print O "$name1\t$total_length\n";
close FASTA;
}
############
}
closedir(DIR);
close O;



