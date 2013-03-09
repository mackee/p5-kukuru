use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Router;

subtest '_build_dest' => sub {
    my $router = Kukuru::Router->new;

    my $dest = $router->_build_dest(
        { controller => 'Root', action => 'index' },
    );

    is_deeply $dest, {controller => 'Root', action => 'index'};
};

subtest '_build_dest' => sub {
    my $router = Kukuru::Router->new;
    my $dest = $router->_build_dest(
        'Root#index',
    );

    is_deeply $dest, {controller => 'Root', action => 'index'};
};

subtest '_build_dest' => sub {
    my $router = Kukuru::Router->new;
    my $dest = $router->_build_dest(
        ['Root#index1', 'Root#index2'],
    );

    is_deeply $dest, {action => [
        {controller => 'Root', action => 'index1'},
        {controller => 'Root', action => 'index2'},
    ]};
};

done_testing;
