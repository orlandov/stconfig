#!/usr/bin/perl
use strict;
use warnings;

my @workspaces = qx(st-admin list-workspaces);
chomp @workspaces;
my $awk = "awk '{print \$1}'";
my $tmpdir = "tmp.$$";
mkdir $tmpdir;

my $st_admin = $ENV{ST_ADMIN} || 'st-admin';

my $nlw_root = $ENV{NLW_ROOT} || "$ENV{HOME}/.nlw/root";
for my $w (@workspaces) {
    my @pages = glob("$nlw_root/data/$w/*");
    my $num_pages = @pages;
    my $page_size = qx(du -hs $nlw_root/data/$w | $awk);
    chomp $page_size;

    my @attachments = glob("$nlw_root/plugin/$w/attachments/*/*.txt");
    my $num_attachs = @attachments;
    my $attach_size = qx(du -hs $nlw_root/plugin/$w/attachments | $awk);
    chomp $attach_size;

    my $start = time;
    qx($st_admin export-workspace --workspace $w --dir $tmpdir);
    my $duration = time - $start;

    my $tarball_size = qx(du -hs $tmpdir/$w.1.tar.gz | $awk);
    chomp $tarball_size;

    my $padded_w = sprintf('%18s', $w);
    print "$padded_w  Pages: $num_pages ($page_size)\tAttachments: $num_attachs ($attach_size)\tExport: ${duration}s ($tarball_size)\n";
}
exit;


