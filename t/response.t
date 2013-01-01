use strict;
use warnings;
use Test::More;
use Kukuru::Response;

subtest 'new' => sub {
    my $res = Kukuru::Response->new(200);
    isa_ok $res, 'Plack::Response';
};

done_testing;
