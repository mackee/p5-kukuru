use strict;
use warnings;
use Test::More;
use Kukuru::Lite;

for my $method (qw(any get patch post put del)) {
    can_ok __PACKAGE__, $method;
}

subtest 'can add routes?' => sub {
    is scalar(@{app->router->routes}), 0;

    get '/' => sub {};

    is scalar(@{app->router->routes}), 1;
};

done_testing;
