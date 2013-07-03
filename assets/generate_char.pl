#!/usr/bin/perl -w

use strict;

if ($#ARGV != 3 )
{
	print 'usage: generate_char.pl "<folder>" "<animation list>" "<dir list>"\n';
	print 'ex: generate_char.pl "assets/red_knight" "paused,run,attack" "ne,nw,se,sw,e,w,n,s"\n';
	exit;
}
# $ARGV[0]
