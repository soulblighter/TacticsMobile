#!/usr/bin/perl -w


#########################################
# Pre-requisite: Run on linux			#
#########################################

# rename 's/\ /_/g' *.bmp
# for f in *.bmp; do convert $f  -transparent '#6F4F33'   ${f%%.bmp}.png; rm $f; done




use strict;
use warnings;

print "size: [".scalar(@ARGV)."] \n";
foreach (@ARGV) { print "$_\n" }


if (scalar(@ARGV) != 1 )
{
	print 'usage: generate_char.pl "<folder>"\n';
	print 'ex: generate_char.pl "red_knight"\n';
	exit;
}
# $ARGV[0]

#my @animations = split(',', $ARGV[1]);
#my @directions = split(',', $ARGV[2]);




# Get parameter wirh folder name where the images are located
my $dir = $ARGV[0];
my @files;	# List os all images files
my %animations; # guard values like: {"animation name" -> "number of frames"}



#########################################
# Part 1: Rename Stopped frames			#
#########################################

my $stoppedFilename = "$dir/stopped0000.png";
if (-e $stoppedFilename) {
	rename "$dir/stopped0000.png", "$dir/stopped_s0000.png";
	rename "$dir/stopped0001.png", "$dir/stopped_sw0000.png";
	rename "$dir/stopped0002.png", "$dir/stopped_w0000.png";
	rename "$dir/stopped0003.png", "$dir/stopped_nw0000.png";
	rename "$dir/stopped0004.png", "$dir/stopped_n0000.png";
	rename "$dir/stopped0005.png", "$dir/stopped_ne0000.png";
	rename "$dir/stopped0006.png", "$dir/stopped_e0000.png";
	rename "$dir/stopped0007.png", "$dir/stopped_se0000.png";
} 


#########################################
# Part 2: List all png files on folder	#
# and figure out animation names		#
#########################################

opendir(DIR, $dir) or die $!;
while (my $file = readdir(DIR)) {
	# We only want files
	next unless (-f "$dir/$file");

	# Use a regular expression to find files ending in .txt
	next unless ($file =~ m/\.png$/);

	push(@files, $file);
	
	my $anim_name = $file;
	$anim_name =~ m/^([a-zA-Z0-9_]+)_(se|sw|ne|nw|e|w|n|s)[0-9]{4}\.png$/;
	$anim_name = $1;
	#print "$anim_name\n";
	
	if ( exists( $animations{$anim_name} ) )
	{
		$animations{$anim_name} += 1;
	}
	else
	{
		$animations{$anim_name}=1;
	}
	#print "$file\n";
}
closedir(DIR);


#########################################
# Part 3: Generate flash.as file with	#
# embed list and animation description	#
#########################################
open (OUTFILE, '>', $dir.".as");

# Print list of embeds
foreach my $val (@files) {

	$val =~ m/^([a-zA-Z_0-9]+)\.png$/;
	my $className = $1;
	print OUTFILE "[Embed(source = '../../../assets/".$dir."/".$val."')]	public var ".$className.":Class;\n";
}

# Print list of animation -> frames number
my($key, $values);
while ( ($key, $values) = each(%animations) )
{
	print OUTFILE "$key -> ".($values/8)."\n";
}

close (OUTFILE); 

exit 0;
	