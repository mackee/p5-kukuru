package Kukuru;
use strict;
use warnings;

use Kukuru::Request;
use Kukuru::Controller;
use Kukuru::Router;
use Kukuru::Renderer;
use Kukuru::Util;

use Mouse;

has router => (
    is => 'rw',
    default => sub { Kukuru::Router->new },
);

has helpers => (
    is => 'rw',
    default => sub { +{} },
);

no Mouse;

sub BUILD {
    my ($self) = @_;
    $self->startup;

    # autobuild controller if fail load "app_controller_class"
    if (Mouse::Util::_try_load_one_class($self->app_controller_class)) {
        Mouse::Meta::Class->initialize($self->app_controller_class)
            ->superclasses($self->controller_class);
    }

    # add helpers for "app_controller_class"
    my $meta = $self->app_controller_class->meta;
    for my $name (keys %{$self->helpers}) {
        $meta->add_method($name => $self->helpers->{$name});
    }
}

sub select_controller_class {
    my ($self, $match) = @_;

    if ($match && $match->{controller}) {
        Kukuru::Util::load_class(
            $match->{controller}, $self->app_controller_class
        );
    }
    else {
        $self->app_controller_class;
    }
}

sub startup {}

sub request_class    { 'Kukuru::Request'    }
sub controller_class { 'Kukuru::Controller' }

sub app_controller_class { shift->meta->name."::Controller" }

__PACKAGE__->meta->make_immutable;
