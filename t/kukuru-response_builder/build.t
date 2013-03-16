use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::ResponseBuilder;

subtest 'BUILD' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;

    my @handlers = qw(template text json data);
    isa_ok $response_builder->handlers->{$_}, 'CODE', $_ for @handlers;
};

done_testing;
