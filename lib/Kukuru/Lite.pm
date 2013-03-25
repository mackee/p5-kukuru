package Kukuru::Lite;
use strict;
use warnings;
use Mouse::Util ();
use Mouse ();

sub import {
    my ($class) = @_;

    my %methods;
    my $caller = caller;

    # extends 'Kukuru' to caller
    my $meta = Mouse->init_meta(for_class => $caller);
    $meta->superclasses('Kukuru');

    my $app = $caller->new;
    for my $name (qw(any get patch post put del)) {
        $methods{$name} = sub { $app->router->$name(@_) };
    }

    Mouse::Util::install_subroutines($caller,
        %methods,
        app    => sub { $app },
        plugin => sub { $app->load_plugin(@_) },
        hook   => sub { $app->add_hook(@_) },
    );
}

1;
