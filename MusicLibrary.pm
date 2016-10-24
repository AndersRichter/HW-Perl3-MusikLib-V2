package Local::MusicLibrary;

BEGIN
{
	use strict;
	use warnings;
	use DDP;
	use Getopt::Long;
	use Exporter();
	our @ISA = "Exporter";
	our @EXPORT = qw(&sosdanie &reshenie);
}

sub sosdanie
{
	my @arr;
	my $w=0;	 
	while (my $row = <STDIN>) 
	{
		chomp $row;
		$row=~ s/\.\///;
		my @spli=split /(?:(\/)|(\d+\s\-\s)|(\.))/,$row;	
		for (my $i=0; $i<= $#spli; $i++)
		{		
			if ((!defined($spli[$i]))||($spli[$i]=~/^\.$/)||($spli[$i]=~/^\/$/)||($spli[$i]=~/^$/))
			{
				splice(@spli,$i,1);
				$i--;
			}
			elsif($spli[$i]=~/^(\d+)\s\-\s$/)
			{	
				$spli[$i] = $1;
				$i--;
			}
		}
		my $group = $spli[0];
		my $year = $spli[1];
		my $album = $spli[2];
		my $trek = $spli[3];
		my $form = $spli[4];	
		$arr[$w] = ( [$group,$year,$album,$trek,$form] );
		$w++;
	}
	return @arr;
}

sub line
{
	my ($len, $in) = @_;
	if ($in == 1)
	{
		print "\/";
		print "-"x$len;
		print "\\\n";
	}
	else
	{
		print "\\";
		print "-"x$len;
		print "\/\n";
	}
}

sub uslovie
{
	my ($in, $str, @arr) = @_;
	my @array;
	if ($in == 1)	{@array = grep { $arr[$_]->[$in] == $str } 0..$#arr;}
	else	{@array = grep { $arr[$_]->[$in] eq $str } 0..$#arr;}
	for (my $i=0; $i <= $#array; $i++)
	{
		my $st = $array[$i];
		@ar[$i] = $arr[$st];
	}	
	return @ar;
}

sub pechat_kolonki
{
	my ($num, $in, @arr) = @_;
	our $max = 0;
	my $str = "| ";
	for (my $i=0; $i <= $#arr; $i++)
	{
		my $size = length($arr[$i][$in]);
		if($size > $max) {$max = $size;}
	}
	my $len = length $arr[$num][$in];
	if ($len < $max)
	{
		my $prob = " "x($max-$len);
		$str = $str.$prob.$arr[$num][$in]." ";
	}
	else { $str = $str.$arr[$num][$in]." ";}
	return $str;
}

sub pechat_all
{
	my ($col, $arr) = @_;
	@col = @$col;
	@arr = @$arr;
	if (@arr == 0) {;}
	else
	{
		my $mega;
		my $size;
		my $str = "";
		for (my $j = 0; $j <= $#arr; $j++)
		{
			$mega = 0;
			my $beet = "|";
			for (my $i = 0; $i <= $#col; $i++)
			{
				if ($col[$i] eq "band") 
				{
					$str = $str.pechat_kolonki($j, 0, @arr);
					$beet = $beet."-"x$max."--";
					if ($i == $#col) {$beet = $beet."|";}
					else {$beet = $beet."+";}
					$mega += $max+3;
				}
				elsif ($col[$i] eq "year") 
				{
					$str = $str.pechat_kolonki($j, 1, @arr);
					$beet = $beet."-"x$max."--";
					if ($i == $#col) {$beet = $beet."|";}
					else {$beet = $beet."+";}
					$mega += $max+3;
				}
				elsif ($col[$i] eq "album") 
				{
					$str = $str.pechat_kolonki($j, 2, @arr);
					$beet = $beet."-"x$max."--";
					if ($i == $#col) {$beet = $beet."|";}
					else {$beet = $beet."+";}
					$mega += $max+3;
				}
				elsif ($col[$i] eq "track") 
				{
					$str = $str.pechat_kolonki($j, 3, @arr);
					$beet = $beet."-"x$max."--";
					if ($i == $#col) {$beet = $beet."|";}
					else {$beet = $beet."+";}
					$mega += $max+3;
				}
				elsif ($col[$i] eq "format") 
				{
					$str = $str.pechat_kolonki($j, 4, @arr);
					$beet = $beet."-"x$max."--";
					if ($i == $#col) {$beet = $beet."|";}
					else {$beet = $beet."+";}
					$mega += $max+3;
				}
			}
			$size = $mega;
			$str = $str."|\n";
			if ($j != $#arr) {$str = $str.$beet."\n";}
		}
		line ($size-1, 1);
		print $str;
		line ($size-1, 2);
	}
}

sub sortirovka
{
	my ($in, @arr) = @_;
	my @array;
	if ($in == 1)	{@array = sort { $a->[$in] <=> $b->[$in]} @arr;}
	else	{@array = sort { $a->[$in] cmp $b->[$in]} @arr;}
	return @array;
}

sub reshenie
{
	my (@arr) = @_;
	my $band = my $year = my $album = my $track = my $format = my $sort = my $columns = 0;
	GetOptions(
	'band=s' => \$band,
	'year=s' => \$year,
	'album=s' => \$album,
	'track=s' => \$track,
	'format=s' => \$format,
	'sort=s' => \$sort,
	'columns=s' => \$columns,
	);
	if ($band ne "0") {@arr = uslovie(0, $band, @arr);}
	if ($year ne "0") {@arr = uslovie(1, $year, @arr);}
	if ($album ne "0") {@arr = uslovie(2, $album, @arr);}
	if ($track ne "0") {@arr = uslovie(3, $track, @arr);}
	if ($format ne "0") {@arr = uslovie(4, $format, @arr);}
	if ($sort ne "0") 
	{
		if ($sort eq "band") {@arr = sortirovka (0, @arr);}
		if ($sort eq "year") {@arr = sortirovka (1, @arr);}
		if ($sort eq "album") {@arr = sortirovka (2, @arr);}
		if ($sort eq "track") {@arr = sortirovka (3, @arr);}
		if ($sort eq "format") {@arr = sortirovka (4, @arr);}
	}
	if ($columns eq "''") {;}
	elsif ($columns ne "0")
	{		
		my @col = split /,/, $columns;
		pechat_all(\@col , \@arr);
	}
	else
	{
		my @col = qw(band year album track format);
		pechat_all(\@col, \@arr);
	}
}

return 1;
END{}
