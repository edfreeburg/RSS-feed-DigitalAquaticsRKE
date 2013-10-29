#  RSS feed parser/logger for Digital Aquatics, Inc. NET module.
#  Last modified by Eric Wilcox-Freeburg: January 29, 2013.
#
#  Before getting started, make sure you download the required
#  packages for Perl.  Also, set static IP addresses for all
#  NET modules and have that available.  The addreses below are
#  those used by our system.  Use the NET detector application
#  if you cannot find these IP.
#
#  If you have one NET module, see "DA_RSS_Single.pl".
#


use XML::RSS::Parser::Lite;
        use LWP::Simple;
		$totcount = 0;
		CRASHRESTART:
		eval {
			$count = 0;
			START:
			$count = $count + 1;
			$totcount = $totcount + 1;
		
			open FILE, ">>", "Eval.txt" or die $!;
			print "Fetching data: all loggers...\n";

			my $xml1 = get("http://192.168.1.30/rss/rss.xml");		#  Each RSS feed is downloaded before data segmentation.
			my $rp1 = new XML::RSS::Parser::Lite;
			$rp1->parse($xml1);
			
			my $xml2 = get("http://192.168.1.45/rss/rss.xml");
			my $rp2 = new XML::RSS::Parser::Lite;
			$rp2->parse($xml2);
			
			my $xml3 = get("http://192.168.1.105/rss/rss.xml");
			my $rp3 = new XML::RSS::Parser::Lite;
			$rp3->parse($xml3);
			
			my $xml4 = get("http://192.168.1.60/rss/rss.xml");
			my $rp4 = new XML::RSS::Parser::Lite;
			$rp4->parse($xml4);
		
			my ($sec, $min, $hr, $day, $mon, $year) = localtime;
			$timest = sprintf("%02d/%02d/%04d %02d:%02d:%02d\n", 
				$day, $mon + 1, 1900 + $year, $hr, $min, $sec);
			print FILE $timest . "Replicate " . $count . "\n";

			my $tot = $rp1->count() + $rp2->count() + $rp3->count() + $rp4->count();		
			#print $tot;
			
			if ($tot == 20) {									# Change this value to match
			for (my $i = 0; $i < $rp1->count(); $i++) {
						my $it = $rp1->get($i);
						$title = $it->get('title');
						$value = $it->get('description');
						print FILE $title . " ";
						print FILE $value . "\n";
			}
					
			

			for (my $i = 0; $i < $rp2->count(); $i++) {
					my $it = $rp2->get($i);
					$title = $it->get('title');
					$value = $it->get('description');
					print FILE $title . " ";
					print FILE $value . "\n";
			}
						

			for (my $i = 0; $i < $rp3->count(); $i++) {
					my $it = $rp3->get($i);
					$title = $it->get('title');
					$value = $it->get('description');
					print FILE $title . " ";
					print FILE $value . "\n";
			}
						

			for (my $i = 0; $i < $rp4->count(); $i++) {
					my $it = $rp4->get($i);
					$title = $it->get('title');
					$value = $it->get('description');
					print FILE $title . " ";
					print FILE $value . "\n";
			}
			print FILE "\n";
			close FILE;
			print "Data saved! ($count/$totcount)\n";
			goto START;
			} else {
			goto ERROR;
			}
		} or do {
		ERROR:
		print "\n\nCommunication error with NET interface, delaying 5 minutes!\n";
		sleep 300;
		print "Restarting script...\n";
		goto CRASHRESTART;
		}	