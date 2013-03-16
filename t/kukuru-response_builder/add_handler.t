use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::ResponseBuilder;

subtest 'add_handler' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;
    ok !$response_builder->handlers->{test};
    $response_builder->add_handler('test' => sub {});

    isa_ok $response_builder->handlers, 'HASH';
    isa_ok $response_builder->handlers->{test}, 'CODE';
};

done_testing;
