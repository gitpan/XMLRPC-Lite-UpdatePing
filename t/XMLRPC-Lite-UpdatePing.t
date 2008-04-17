use strict;
use Test::More qw(no_plan);

BEGIN { use_ok('XMLRPC::Lite::UpdatePing') };

my $client = XMLRPC::Lite::UpdatePing->new;
ok $client;

my $feed = { 'the radius of 5 meters' => 'http://seratch.blogspot.com/feeds/posts/default' };
ok $client->ping($feed);
