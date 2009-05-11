package Wasted;
use strict;
use warnings;
use Time::HiRes qw/gettimeofday tv_interval/;
use base 'Exporter';

our @EXPORT = qw/waste_of_time/;
our $LOG_FILE = '/var/log/wasted-time.log';


sub waste_of_time {
    my $reason = shift;
    my $time_waster = shift;
    $reason = defined $reason ? " - $reason" : '';

    my $t0 = [gettimeofday];
    $time_waster->();
    my $elapsed = tv_interval($t0);

    if (-w $LOG_FILE) {
        open(my $fh, ">>$LOG_FILE") or die "Can't open $LOG_FILE - $!";
        print $fh "$ENV{USER} - $elapsed$reason\n";
        close $fh or die "Can't write to $LOG_FILE: $!";
    }
}


1;
