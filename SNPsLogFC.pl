#!/usr/bin/perl
$snps= 'data/HeadTorax.cmh.LogFC-no-cutoff.txt';
#$snps= 'data/Abdomen.cmh.LogFC-no-cutoff.txt';

########
%allCDS = ();
open (INFO, $snps) or die ("open: $!");
while (defined ($lines = <INFO>))
{
	chomp $lines;
	@ID = split(/	/,$lines);
	$allCDS{@ID[1]} = "@ID[3]	$allCDS{@ID[1]}";
}
foreach $key (keys %allCDS)
{
	@pvalue = split(/	/,$allCDS{$key});
	use List::Util qw( min max );
	my $min = min @pvalue;
	my $max = max @pvalue;
	$allCDS{$key} = $max;
}
close(INFO);

$c=1;
print "GeneID	LogFC	CMH\n";
open (INFO, $snps) or die ("open: $!");
while (defined ($lines = <INFO>))
{
	chomp $lines;
	@ID = split(/	/,$lines);
	if (exists $allCDS{@ID[1]})
	{
		if ($allCDS{@ID[1]} eq @ID[3])
		{
			print "@ID[1]	@ID[2]	@ID[3]\n";$c++;
		}
	}
}
close(INFO);