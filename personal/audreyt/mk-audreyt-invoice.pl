#!/usr/bin/perl
use utf8;
use encoding 'utf8';
use strict;
use DateTime;
use List::Util 'sum';
use Number::Format qw(:subs);
use Socialtext::Resting;
use DateTime::Duration;

chomp(my $username = `git config user.email`);
$username = 'audrey.tang@socialtext.com' if !$username or $username =~ /audreyt/;
$username = $ENV{ST_USER} || $username;

my $server      = $ENV{ST_SERVER} || 'https://www2.socialtext.net/';
my $password    = $ENV{ST_PASSWORD} || do {
    require Term::ReadPassword;
    read_password("Password for $username at $server: ")
};
my $hourly_rate = $ENV{ST_HOURLY_RATE} || 90;

my $Rester      = Socialtext::Resting->new(
    username => $username,
    server   => $server,
    password => $password,
);

$Rester->workspace($ENV{ST_WORKSPACE} || 'conversation');
$| = 1;

# "Week 0" of my time in Socialtext
my $wk0 = DateTime->new(
    year  => 2008,
    month => 7,
    day   => 27,
);

my @weeks = sort(@ARGV || do {
    my $wk_prev = (
        (
            DateTime->now->delta_days($wk0) -
                DateTime::Duration->new(days => 6)
        )->in_units('weeks')
    );
    ($wk_prev - 1, $wk_prev);
});

my $invoice_date = ($wk0 + DateTime::Duration->new(weeks => $weeks[-1], days => 6))->ymd;

print << ".";

Invoice $invoice_date, Audrey Tang

.

my $grand_total = 0;
for my $wk (@weeks) {
    print "^^^ Week $wk\n\n";
    my $start = $wk0 + DateTime::Duration->new(weeks => $wk);
    my $end = $wk0 + DateTime::Duration->new(weeks => $wk, days => 6);

    my @pages = sort grep {
        /^(\d\d\d\d)-(\d\d)-(\d\d)/ and do {
            my $d = DateTime->new(
                year  => $1,
                month => $2,
                day   => $3,
            );
            $d >= $start and $d <= $end;
          }
    } $Rester->get_taggedpages($ENV{ST_TAG} || 'audreyt blog');

    print "| _Dates_ | ";

    my @hours;
    for (@pages) {
        /^\d\d\d\d-(\d\d)-(\d\d)/ or next;
        print "$1-$2 | ";
        push @hours,
          sum(map { /(\d*)(\D+)/ ? (($1 || 0) + 0.5) : $_ }
              ($Rester->get_page($_) =~ m/^\^.*\((.+)\s*hr/mg));
    }

    print "*Total* |\n";
    print "| _Hours_ | ";

    my $total = sum(@hours);
    $grand_total += $total;

    for (@hours) {
        s/\.5/½/;
        printf "%5s | ", $_;
    }
    $total =~ s/\.5/½/;
    printf "%7s |\n\n", "*$total*";
}

my $billable = format_number($grand_total * $hourly_rate);
$grand_total =~ s/\.5/½/;

print << ".";
----

Hourly rate: \$$hourly_rate USD
Total Time Spent: $grand_total hours
*Total Amount Due*: \$$billable USD
.
