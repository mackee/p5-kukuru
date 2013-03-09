use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Router;

subtest 'routes' => sub {
    my $router = Kukuru::Router->new;
    is ref $router->routes, 'ARRAY';
    ok !scalar(@{$router->routes});

    $router->get('/' => sub {});

    is ref $router->routes, 'ARRAY';
    ok scalar(@{$router->routes});
};

done_testing;
