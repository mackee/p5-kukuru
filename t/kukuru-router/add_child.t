use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Router;

subtest 'add_child' => sub {
    my $router1 = Kukuru::Router->new;
    my $route   = $router1->get('/' => 'Root#index');

    my $router2 = Kukuru::Router->new;
    $router2->add_child($route);

    is scalar(@{$router2->routes}), 1;
};

done_testing;
