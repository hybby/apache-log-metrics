#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
$| = 0;            
my $script     = $0;
my $input_file = $ARGV[0];

my $usage      = qq(
usage: $script [-h|--help] file

required arguments:

    file          path to apache access log file to parse

optional arguments:
   
    -h, --help    show this help message and exit

);

# arg parsing.  we'll take either -h, --help, or a file.
scalar(@ARGV) == 1 or die "$script: must provide one file to process\n";

if ($input_file eq '--help' || $input_file eq '-h') {
  print $usage;
  exit; 
} else {
  -f $input_file     or die "$script: file \"$input_file\" does not exist\n";
}

# open our file
open(my $fh, '<', $input_file) or die "cannot open $input_file: $!\n";

# homegrown regexp of a valid log line, capturing datetime, response code, bytes sent and response time.
my $match = '[A-Za-z0-9_\-\:\.]+ - - \[(\d+)\/(\w+)\/(\d+)\:(\d+)\:(\d+)\:(\d+) \+\d+\] \".*\" (\d+) ([\d\-]+) (\d+)';

# let's initialise the hash we'll keep our statistics in.  let's also count valid lines.
my %stats;
my $total_lines     = 0;
my $matched_lines   = 0;
my $unmatched_lines = 0;

# parse our logs
while ( my $line = <$fh> ) {
  chomp $line;
  $total_lines++;
  
  if ($line =~ m/^$match$/) {
    $matched_lines++;

    # let's get a unique key for our hash, down to the minute.  and grab our other captured stuff.
    my $datetime       = "$1/$2/$3 $4:$5"; 
    my $http_rc        = $7;
    my $response_bytes = $8;
    my $response_time  = $9;

    # initialise our "object" if we haven't seen this datetime before
    if ( ! $stats{$datetime} ) {
      $stats{$datetime}{'successful_reqs'}   = 0;
      $stats{$datetime}{'error_reqs'}        = 0;
      $stats{$datetime}{'response_bytes'}    = 0;
      @{$stats{$datetime}{'response_times'}} = ();
    }

    # http codes in the 4xx and 5xx range are errors
    if ($http_rc !~ m/[45]+/) {
      $stats{$datetime}{'successful_reqs'}++;
    } else {
      $stats{$datetime}{'error_reqs'}++;
    } 

    # running total of bytes for this minute. log is clf format, so - instead of 0.
    $response_bytes eq '-' and $response_bytes = 0;
    $stats{$datetime}{'response_bytes'} += $response_bytes;

    # response times in microseconds.  add to list to avg later.
    push(@{$stats{$datetime}{'response_times'}}, $response_time);

  } else { 
    $unmatched_lines++;
    #warn "line found which does not match our apache log format";
    #print $line . "\n";
  } 
}

# wanna check out my hash? just uncomment these two lines:
# print Dumper(\%stats);
# exit;

foreach my $key (sort keys %stats) {

  my $successful_reqs = $stats{$key}{'successful_reqs'};
  my $error_reqs      = $stats{$key}{'error_reqs'};

  # convert our response bytes to mb
  my $response_bytes  = $stats{$key}{'response_bytes'};
  my $response_mb     = ($response_bytes / 1024 / 1024);

  # average our list of response times.
  my $sum_rt = 0;
  foreach my $time (@{$stats{$key}{'response_times'}}) {
    $sum_rt += $time;
  }
  
  # since we stored our response times in microseconds, convert to seconds
  my $avg_rt_us = ($sum_rt / scalar(@{$stats{$key}{'response_times'}})); 
  my $avg_rt_s  = ($avg_rt_us / 1000000.0);

  # finally, print out the metrics for this minute
  print "$key - successful_reqs: $successful_reqs, error_reqs: $error_reqs, mb_sent_per_min: $response_mb, avg_response_per_min: $avg_rt_s secs\n";
}

# finally, let's print out valid and invalid lines to be sure we completely parsed the file.
if ($matched_lines == 0) {
  die "$script: looks like you provided an invalid log file; we couldn't process any lines\n";
} else {
  print "\nsummary: processed $input_file - $total_lines lines total, $matched_lines processed, $unmatched_lines invalid\n";
}

close($fh);


