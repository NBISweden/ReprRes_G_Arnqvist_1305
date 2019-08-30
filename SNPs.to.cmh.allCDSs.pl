#!/usr/bin/perl

# INPUT INFO

@fileList= ('data/rc3_longestCDSperGene.gff');
$Fst="Bra.Ca.Yem.idf.fst";
$Cmh="Bra.Ca.Yem.idf.cmh";

foreach $list (@fileList)
{
	# create a SNPs file
	print "$list\n";
	@name = split(/\//,$list);
	@name = split(/\./,@name[1]);
	open (OUTFILE, ">SNPs.cmh.Gff.txt");
	close(OUTFILE);

	# put all quiver list in a hash
	%contigsLIST = ();
	open (INFO, $list) or die ("open: $!");
	while (defined ($lines = <INFO>))
	{
		chomp $lines;
		@contig = split(/	/,$lines);
		#print "@contig[0]\n";
		if (@contig[2] eq 'CDS')
		{
			@contig = split(/\|/,@contig[0]);
			#print "@contig[0]\n";
			$contigsLIST{@contig[0]} = @contig[0];
		}
	}
	close(INFO);
	@contigsINlist = keys %contigsLIST;
	$sizecontigsINlist = @contigsINlist;
	print "Contigs in all lists	$sizecontigsINlist\n";

	# put all quiver from fst file in a hash
	$number = 1;
	%contigsLISTfst = ();
	open (INFO1, $Fst) or die ("open: $!");
	while (defined ($lines1 = <INFO1>))
	{
		chomp $lines1;
		@contigFST = split(/	/,$lines1);
		#print "@contigFST[0]\n";
		@contigFST = split(/\|/,@contigFST[0]);
		#print "@contigFST[0]\n";
		if (exists $contigsLIST{@contigFST[0]})
		{
			#print "@contigFST[0]\n";
			#$contigsLISTfst{$number} = $lines1;
			#$number++;
			$contigsLISTfst{@contigFST[0]} = join('/', $contigsLISTfst{@contigFST[0]},$lines1);
			#print "$contigsLISTfst{@contigFST[0]}\n";
		}
	}
	close(INFO1);
	@contigsINlistFST = keys %contigsLISTfst;
	$contigsFST = @contigsINlistFST;
	print "Contigs fst in all lists	$contigsFST\n";

	# put all quiver from cmh file in a hash
	%contigsLISTcmh = ();
	open (INFO2, $Cmh) or die ("open: $!");
	while (defined ($lines2 = <INFO2>))
	{
		chomp $lines2;
		@contigCMH = split(/	/,$lines2);
		#print "@contigCMH[0]\n";
		@contigCMH = split(/\|/,@contigCMH[0]);
		#print "@contigCMH[0]\n";
		if (exists $contigsLIST{@contigCMH[0]})
		{
			#print "@contigCMH[0]\n";
			#$contigsLISTcmh{$number} = $lines2;
			#$number++;
			$contigsLISTcmh{@contigCMH[0]} = join('/', $contigsLISTcmh{@contigCMH[0]},$lines2);
			#print "$contigsLISTcmh{@contigCMH[0]}\n";
		}
	}
	close(INFO2);
	@contigsINlistCMH = keys %contigsLISTcmh;
	$contigsCMH = @contigsINlistCMH;
	print "Contigs cmh in all lists	$contigsCMH\n";

	# extract SNPs using hash fst list
	open (INFO, $list) or die ("open: $!");
	while (defined ($lines = <INFO>))
	{
		chomp $lines;
		@gff = split(/	/,$lines);
		@quiver1 = split(/\|/,@gff[0]);

		if (exists $contigsLISTfst{@quiver1[0]})
		{
			@contigValues = split(/\//,$contigsLISTfst{@quiver1[0]});
			foreach $FST (@contigValues)
			{
				chomp $FST;
				#print "$FST\n";
				@fst = split(/	/,$FST);
				@quiver = split(/\|/,@fst[0]);
				#print "@fst[0]	@fst[1]\n";

				#print "@gff[0]	@gff[3]	@gff[4]  @fst[0]  @fst[1]\n";

				if ((@quiver[0] eq @quiver1[0]) && (@gff[3] <= @fst[1]) && (@gff[4] >= @fst[1]))
				{
					@contigValuesCMH = split(/\//,$contigsLISTcmh{@quiver1[0]});
					foreach $CMH (@contigValuesCMH)
					{
						chomp $CMH;
						#print "$CMH\n";
						@cmh = split(/	/,$CMH);
						@quiver2 = split(/\|/,@cmh[0]);
						#print "@quiver2[0]	@cmh[1]	@quiver[0]	@fst[1]\n";
						if ((@quiver2[0] eq @quiver[0]) && (@cmh[1] eq @fst[1]))
						{
							@cdsonly = split(/	/,$lines);
							if (@cdsonly[2] eq 'CDS')
							{
								#print "@fst[0]	@fst[1]	$lines\n";
								open (OUTFILE, ">>SNPs.cmh.Gff.txt");
								print OUTFILE "@fst[0]	@fst[1]	$lines	$CMH\n";
								close(OUTFILE);
							}
						}
					}
				}
			}
		}
	}
	close(INFO);
}
