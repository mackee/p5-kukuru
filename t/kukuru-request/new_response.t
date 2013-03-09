use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Request;

subtest 'new_response: default' => sub {
    my $req = Kukuru::Request->new({});
    isa_ok $req->new_response, "Kukuru::Response";
};

done_testing;
