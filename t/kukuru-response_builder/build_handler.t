use strict;
use warnings;
use Test::More;
use Kukuru::ResponseBuilder;

subtest 'build_handler' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;
    is $response_builder->build_handler(template => 1), 'template';
    is $response_builder->build_handler(json => 1), 'json';
    is $response_builder->build_handler(file => 1), 'file';
    is $response_builder->build_handler(data => 1), 'data';
};

subtest 'build_handler with handler' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;
    my $handler = $response_builder->build_handler(
        json    => {},
        handler => 'user_handler1'
    );
    is $handler, 'user_handler1';
};

subtest 'build_handler with default_handler' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;
    my $handler = $response_builder->build_handler();
    is $handler, 'template';
};

done_testing;
