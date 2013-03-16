use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::ResponseBuilder;

subtest 'handlers' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;
    isa_ok $response_builder->handlers, 'HASH';
};

done_testing;
