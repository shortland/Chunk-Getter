#!/usr/bin/perl

# Grab chunk of data
# Very inefficient as it literarily reads through a chunk character by character...

use warnings;
use File::Slurp;

$datas = read_file("main.txt");

$errorText = "An Error Occured, possibly out of bounds.";

for($l = 1; $l < lengthOfData($datas); $l++) {
	print "The string at position " . $l . " is: '" . slicer($datas, $l) . "'\n";
}

sub slicer {
	my ($data, $amt) = @_;

	$j = 1;
	$beginFrag = 0;
	for($i = 2; $i <= length($data); $i++) {
		if(substr($data, $i-1, 1) =~ /^({)$/) {
			$beginFrag = $i-1;
			$j++;
		}
		elsif(substr($data, $i-1, 1) =~ /^(})$/) {
			$j--;
		}

		if($j == 1 && $i > 2 && (substr($data, $i-1, 1) =~ /^(})$/)) {

			$chunk = substr($data, $beginFrag, ($i - 1));

			$data =~ s/$chunk//;

			if(substr($chunk, (length($chunk) - 1), 1) =~ /^( )$/) {
				
				$chunk = substr($chunk, 0, length($chunk)-1);
				if(substr($chunk, (length($chunk) - 1), 1) =~ /^(,)$/) {
					$chunk = substr($chunk, 0, length($chunk)-1);
				}
			}

			$chunk = substr($chunk, 1, length($chunk)-2); # remove leading and laggin slag

			# last one issue
			if(substr($chunk, length($chunk)-1, 1) =~ /^(})$/) {
				$chunk = substr($chunk, 0, length($chunk)-1);
			}

			if(($amt - 1) == 0) {
				return $chunk;
			}
			else {
				return slicer($data, ($amt-1));
			}
		}
	}
	return $errorText;
}

sub lengthOfData {
	my ($data) = @_;

	for($k = 1; $k < length($datas); $k++) {
		if(slicer($datas, $k) =~ /^($errorText)$/) {
			return $k;
			last;
		}
	}
}