use strict;
use warnings;
use Test::More;
use Kukuru::Request;

subtest 'session' => sub {
    my $req = Kukuru::Request->new({
        'psgix.session' => {},
        'psgix.session.options' => {},
    });

    isa_ok $req->session, 'Plack::Session';
};

done_testing;
