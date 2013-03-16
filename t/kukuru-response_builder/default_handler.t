use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::ResponseBuilder;

subtest 'default_handler' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;

    is $response_builder->default_handler, 'template';
};

done_testing;
