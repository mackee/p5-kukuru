use strict;
use warnings;
use Test::More;
use Kukuru::Request;

subtest 'new' => sub {
    my $req = Kukuru::Request->new({});
    isa_ok $req, 'Plack::Request';
};

subtest 'error' => sub {
    eval { Kukuru::Request->new };
    like $@, qr/\$env is required/;
};

done_testing;
