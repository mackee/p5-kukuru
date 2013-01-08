package Kukuru;
use 5.10.1;
use strict;
use warnings;

our $VERSION = "0.01";

use Kukuru::Request;
use Kukuru::Controller;
use Kukuru::Router;
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

has lint => (
    is => 'rw',
    default => 1,
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

    if ($self->lint) {
        # lint your application routes
        my $routes = $self->router->routes;
        for my $route (@$routes) {
            my $controller = $route->{dest}->{controller} or next;
            my $action = $route->{dest}{action};
            my $klass  = Kukuru::Util::load_class($controller, $self->app_controller_class);

            if (!($self->app_controller_class ~~ [$klass->meta->superclasses])) {
                Carp::croak(qq!"$klass" must extend "@{[$self->app_controller_class]}"!);
            }

            if (!$klass->can($action)) {
                Carp::croak(qq!Undefined action &${klass}::$action!);
            }
        }
    }
}

sub to_psgi {
    my $class = shift;
    my $self  = blessed $class ? $class : $class->new;

    sub {
        my $env   = shift;
        my $match = $self->router->match($env);
        my $klass = $self->select_controller_class($match);

        my $c = $klass->new(
            app   => $self,
            req   => $self->request_class->new($env),
            match => $match,
        );

        # response to psgi spec
        $c->dispatch($match)->finalize;
    };
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
