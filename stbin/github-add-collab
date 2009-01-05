#!/usr/bin/perl
use warnings;
use strict;

my $LOGIN = 'socialtext';
my $user = shift || die "must supply user";
my $password = shift || die "must supply socialtext's password";

use JSON::XS qw/decode_json/;
use LWP::UserAgent;
use HTTP::Request::Common qw(GET POST);
use HTTP::Cookies ();

my $cookies = HTTP::Cookies->new(
    file => "$ENV{HOME}/.github.cookies.txt",
    autosave => 1,
);

my $ua = LWP::UserAgent->new(
    requests_redirectable => ['GET','POST'],
    cookie_jar => $cookies,
);

my $login_resp = $ua->request(POST "https://github.com/session" => [
    login => $LOGIN,
    password => $password,
]);
unless ($login_resp->is_success) {
    warn $login_resp->header('Location').$/;
    die $login_resp->code . " " .$login_resp->message.$/;
}

my $json = $ua->get("https://github.com/api/v1/json/$LOGIN");
my $struct = decode_json($json->content);
my $repos = $struct->{user}{repositories};
foreach my $repo (@$repos) {
    print "$repo->{name}: private? $repo->{private}\n";
    add_collaborator($repo->{name});
}

sub add_collaborator {
    my $repo = shift;

    my $uri = "https://github.com/$LOGIN/$repo/edit/add_member";
    my $post = POST $uri, [
        member => $user
    ];
    $post->header('Referer' => "https://github.com/$LOGIN/$repo/edit/collaborators");
    my $res = $ua->request($post);

    if ($res->is_success) {
        print "added $user to repo $repo\n";
    }
    else {
        warn "failed to add $user to repo $repo\n";
    }
}

