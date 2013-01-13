package Kukuru::Lite;
use strict;
use warnings;
use Data::Util qw(install_subroutine);
use Mouse ();

sub import {
    my ($class) = @_;

    my %methods;
    my $caller = caller;

    # extends 'Kukuru' to caller
    my $meta = Mouse->init_meta(for_class => $caller);
    $meta->superclasses('Kukuru');

    my $app = $caller->new;
    for my $name (qw(any get options patch post put del)) {
        $methods{$name} = sub { $app->router->$name(@_) };
    }

    install_subroutine($caller,
        %methods,
        app => sub { $app },
    );
} # use Mouse::Exporter ?

1;
