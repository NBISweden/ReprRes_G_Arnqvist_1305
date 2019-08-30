#!/usr/bin/perl

# INPUT INFO
$list= "SNPs.cmh.Gff.txt";

%CDSs = ();
$cutoff = 0.03;
$c = 2;

open (INFO, $list) or die ("open: $!");
while (defined ($lines = <INFO>))
{
	chomp $lines;
	@base = split(/	/,$lines);
	#2:0:0:13:0:0    4:0:0:9:0:0     13:0:0:0:0:0    15:0:0:1:0:0    23:0:0:0:0:0 29:0:0:1:0:0
	@Bra1 = split(/:/,@base[14]);@Bra2 = split(/:/,@base[15]);@Cal1 = split(/:/,@base[16]);@Cal2 = split(/:/,@base[17]);@Yem1 = split(/:/,@base[18]);@Yem2 = split(/:/,@base[19]);
	#print "@base[14]\n";
	@cds = split(/\;/,@base[10]);
	@cds = split(/\=/,@cds[1]);
	if (@base[4] eq "CDS")
	#if ((@base[4] eq "CDS") && (@base[20] < $cutoff))
	{
		# SNPs in the 3 pop at least present in one sample
		#if ((((@Bra1[0] > $c) && (@Bra1[1] > $c)) || ((@Bra2[0] > $c) && (@Bra2[1] > $c))) && (((@Cal1[0] > $c) && (@Cal1[1] > $c)) || ((@Cal2[0] > $c) && (@Cal2[1] > $c))) && (((@Yem1[0] > $c) && (@Yem1[1] > $c)) || ((@Yem2[0] > $c) && (@Yem2[1] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		#if ((((@Bra1[0] > $c) && (@Bra1[2] > $c)) || ((@Bra2[0] > $c) && (@Bra2[2] > $c))) && (((@Cal1[0] > $c) && (@Cal1[2] > $c)) || ((@Cal2[0] > $c) && (@Cal2[2] > $c))) && (((@Yem1[0] > $c) && (@Yem1[2] > $c)) || ((@Yem2[0] > $c) && (@Yem2[2] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		#if ((((@Bra1[0] > $c) && (@Bra1[3] > $c)) || ((@Bra2[0] > $c) && (@Bra2[3] > $c))) && (((@Cal1[0] > $c) && (@Cal1[3] > $c)) || ((@Cal2[0] > $c) && (@Cal2[3] > $c))) && (((@Yem1[0] > $c) && (@Yem1[3] > $c)) || ((@Yem2[0] > $c) && (@Yem2[3] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		
		#if ((((@Bra1[1] > $c) && (@Bra1[2] > $c)) || ((@Bra2[1] > $c) && (@Bra2[2] > $c))) && (((@Cal1[1] > $c) && (@Cal1[2] > $c)) || ((@Cal2[1] > $c) && (@Cal2[2] > $c))) && (((@Yem1[1] > $c) && (@Yem1[2] > $c)) || ((@Yem2[1] > $c) && (@Yem2[2] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		#if ((((@Bra1[1] > $c) && (@Bra1[3] > $c)) || ((@Bra2[1] > $c) && (@Bra2[3] > $c))) && (((@Cal1[1] > $c) && (@Cal1[3] > $c)) || ((@Cal2[1] > $c) && (@Cal2[3] > $c))) && (((@Yem1[1] > $c) && (@Yem1[3] > $c)) || ((@Yem2[1] > $c) && (@Yem2[3] > $c)))){$CDSs{@cds[1]} = @cds[1];}
	
		#if ((((@Bra1[2] > $c) && (@Bra1[3] > $c)) || ((@Bra2[2] > $c) && (@Bra2[3] > $c))) && (((@Cal1[2] > $c) && (@Cal1[3] > $c)) || ((@Cal2[2] > $c) && (@Cal2[3] > $c))) && (((@Yem1[2] > $c) && (@Yem1[3] > $c)) || ((@Yem2[2] > $c) && (@Yem2[3] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		
		# SNPs in the 3 pop present in both samples
		#if ((((@Bra1[0] > $c) && (@Bra1[1] > $c)) && ((@Bra2[0] > $c) && (@Bra2[1] > $c))) && (((@Cal1[0] > $c) && (@Cal1[1] > $c)) && ((@Cal2[0] > $c) && (@Cal2[1] > $c))) && (((@Yem1[0] > $c) && (@Yem1[1] > $c)) && ((@Yem2[0] > $c) && (@Yem2[1] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		#if ((((@Bra1[0] > $c) && (@Bra1[2] > $c)) && ((@Bra2[0] > $c) && (@Bra2[2] > $c))) && (((@Cal1[0] > $c) && (@Cal1[2] > $c)) && ((@Cal2[0] > $c) && (@Cal2[2] > $c))) && (((@Yem1[0] > $c) && (@Yem1[2] > $c)) && ((@Yem2[0] > $c) && (@Yem2[2] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		#if ((((@Bra1[0] > $c) && (@Bra1[3] > $c)) && ((@Bra2[0] > $c) && (@Bra2[3] > $c))) && (((@Cal1[0] > $c) && (@Cal1[3] > $c)) && ((@Cal2[0] > $c) && (@Cal2[3] > $c))) && (((@Yem1[0] > $c) && (@Yem1[3] > $c)) && ((@Yem2[0] > $c) && (@Yem2[3] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		
		#if ((((@Bra1[1] > $c) && (@Bra1[2] > $c)) && ((@Bra2[1] > $c) && (@Bra2[2] > $c))) && (((@Cal1[1] > $c) && (@Cal1[2] > $c)) && ((@Cal2[1] > $c) && (@Cal2[2] > $c))) && (((@Yem1[1] > $c) && (@Yem1[2] > $c)) && ((@Yem2[1] > $c) && (@Yem2[2] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		#if ((((@Bra1[1] > $c) && (@Bra1[3] > $c)) && ((@Bra2[1] > $c) && (@Bra2[3] > $c))) && (((@Cal1[1] > $c) && (@Cal1[3] > $c)) && ((@Cal2[1] > $c) && (@Cal2[3] > $c))) && (((@Yem1[1] > $c) && (@Yem1[3] > $c)) && ((@Yem2[1] > $c) && (@Yem2[3] > $c)))){$CDSs{@cds[1]} = @cds[1];}
	
		#if ((((@Bra1[2] > $c) && (@Bra1[3] > $c)) && ((@Bra2[2] > $c) && (@Bra2[3] > $c))) && (((@Cal1[2] > $c) && (@Cal1[3] > $c)) && ((@Cal2[2] > $c) && (@Cal2[3] > $c))) && (((@Yem1[2] > $c) && (@Yem1[3] > $c)) && ((@Yem2[2] > $c) && (@Yem2[3] > $c)))){$CDSs{@cds[1]} = @cds[1];}
		
		# SNPs in the 3 pop present in both samples at a proportion of at least 30/70 (sum of both samples)
		if (((@Bra1[0]+@Bra2[0]) > $c) && ((@Bra1[1]+@Bra2[1]) > $c) && ((@Yem1[0]+@Yem2[0]) > $c) && ((@Yem1[1]+@Yem2[1]) > $c) && ((@Cal1[0]+@Cal2[0]) > $c) && ((@Cal1[1]+@Cal2[1]) > $c)){$CDSs{@cds[1]} = @cds[1];}
		if (((@Bra1[0]+@Bra2[0]) > $c) && ((@Bra1[2]+@Bra2[2]) > $c) && ((@Yem1[0]+@Yem2[0]) > $c) && ((@Yem1[2]+@Yem2[2]) > $c) && ((@Cal1[0]+@Cal2[0]) > $c) && ((@Cal1[2]+@Cal2[2]) > $c)){$CDSs{@cds[1]} = @cds[1];}
		if (((@Bra1[0]+@Bra2[0]) > $c) && ((@Bra1[3]+@Bra2[3]) > $c) && ((@Yem1[0]+@Yem2[0]) > $c) && ((@Yem1[3]+@Yem2[3]) > $c) && ((@Cal1[0]+@Cal2[0]) > $c) && ((@Cal1[3]+@Cal2[3]) > $c)){$CDSs{@cds[1]} = @cds[1];}
		
		if (((@Bra1[1]+@Bra2[1]) > $c) && ((@Bra1[2]+@Bra2[2]) > $c) && ((@Yem1[1]+@Yem2[1]) > $c) && ((@Yem1[2]+@Yem2[2]) > $c) && ((@Cal1[1]+@Cal2[1]) > $c) && ((@Cal1[2]+@Cal2[2]) > $c)){$CDSs{@cds[1]} = @cds[1];}
		if (((@Bra1[1]+@Bra2[1]) > $c) && ((@Bra1[3]+@Bra2[3]) > $c) && ((@Yem1[1]+@Yem2[1]) > $c) && ((@Yem1[3]+@Yem2[3]) > $c) && ((@Cal1[1]+@Cal2[1]) > $c) && ((@Cal1[3]+@Cal2[3]) > $c)){$CDSs{@cds[1]} = @cds[1];}
		
		if (((@Bra1[2]+@Bra2[2]) > $c) && ((@Bra1[3]+@Bra2[3]) > $c) && ((@Yem1[2]+@Yem2[2]) > $c) && ((@Yem1[3]+@Yem2[3]) > $c) && ((@Cal1[2]+@Cal2[2]) > $c) && ((@Cal1[3]+@Cal2[3]) > $c)){$CDSs{@cds[1]} = @cds[1];}
		
		#print "$lines\n";

	}
}
foreach $key (keys %CDSs)
{
	print "$key\n";
}
@nbCDSs = keys %CDSs;
$numberCDS = @nbCDSs;
print "$numberCDS\n";
	