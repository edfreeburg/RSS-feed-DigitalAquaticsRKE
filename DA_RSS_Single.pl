#  RSS feed parser/logger for Digital Aquatics, Inc. NET module.
#  Last modified by Eric Wilcox-Freeburg: January 29, 2013.
#
#  Before getting started, make sure you download the required
#  packages for Perl.  Also, set static IP addresses for your
#  NET module and have that available.  The address below is the
#  default when self assigned.  Use the NET detector application
#  if you cannot find this IP.
#
#  If you have more than one NET module, see "DA_RSS_Multiple.pl".
#

use XML::RSS::Parser::Lite;
        use LWP::Simple;
		CRASHRESTART:
		eval {
			$count = 0;
			
			START:
			$count = $count + 1;								# Counts number of sucessful replicates.
			$totcount = $totcount + 1;							# Counts total replicates since last script restart.
		
			open FILE, ">>", "RSS_parser_demo.txt" or die $!;	# Text file title with file append.
			print "Fetching data...\n";

			my $xml = get("http://192.168.1.3/rss/rss.xml");	# Input the local IP address for your NET unit.
			my $rp = new XML::RSS::Parser::Lite;
			$rp->parse($xml);
		
			my ($sec, $min, $hr, $day, $mon, $year) = localtime;
			$timest = sprintf("%02d/%02d/%04d %02d:%02d:%02d\n", 
				$day, $mon + 1, 1900 + $year, $hr, $min, $sec);
			print FILE $timest . "Replicate " . $count . "\n";

			for (my $i = 0; $i < $rp->count(); $i++) {			# Pulls data and creates data matrix.
					my $it = $rp->get($i);
					$title = $it->get('title');
					$value = $it->get('description');
					print FILE $title . " ";					# Appends to FILE.
					print FILE $value . "\n";
			}
			print FILE "\n";
			close FILE;
			print "Data saved! ($count/$totcount)\n";
			sleep 1;				# Change this value (in seconds) to change replicate read delay times.
			goto START;
		} or do {
		print "\n\nCommunication error with NET interface, delaying 5 seconds!\n";
		sleep 5;					# Change this value (in seconds) to change communication error delay time.
		print "Restarting script...\n";
		goto CRASHRESTART;
		}	