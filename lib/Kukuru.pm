package Kukuru;
use 5.10.1;
use strict;
use warnings;

our $VERSION = "0.01";

use Kukuru::Request;
use Kukuru::Controller;
use Kukuru::Router;
use Kukuru::Util;
use Kukuru::Renderer;
use Kukuru::Transaction;

use Mouse;

has router => (
    is => 'rw',
    default => sub { Kukuru::Router->new },
);

has helpers => (
    is => 'rw',
    default => sub { +{} },
);

has hooks => (
    is => 'rw',
    default => sub { +{} },
);

has renderer => (
    is => 'rw',
    default => sub { Kukuru::Renderer->new }
);

has template_engine => (
    is => 'rw',
);

has lint => (
    is => 'rw',
    default => 1,
);

no Mouse;

sub BUILD {
    my ($self) = @_;

    # auto-build controller if fail load "app_controller_class"
    if (Mouse::Util::_try_load_one_class($self->app_controller_class)) {
        my $meta = Mouse->init_meta(for_class => $self->app_controller_class);
        $meta->superclasses($self->controller_class);
    }

    # startup
    $self->startup;

    # add helpers for "app_controller_class"
    my $meta = $self->app_controller_class->meta;
    for my $name (keys %{$self->helpers}) {
        $meta->add_method($name => $self->helpers->{$name});
    }

    if ($self->lint) {
        # lint your application routes
        # - app_controller_classにKukuru::Controllerが継承されているか
        # - Controllerにextendsされているか
        # - Controllerの中にactionがあるか
    }
}

sub to_psgi {
    my $class = shift;
    my $self  = blessed $class ? $class : $class->new;

    sub {
        my $env   = shift;
        my $match = $self->router->match($env);
        my $tx = Kukuru::Transaction->new(
            app   => $self,
            req   => $self->request_class->new($env),
            match => $match,
        );
        $tx->dispatch->finalize;
    };
}

sub load_plugin {
    my ($self, $plugin, $options) = @_;
    my $klass = Kukuru::Util::load_class($plugin, 'Kukuru::Plugin');

    $klass->init($self, $options || {});
}

sub add_hook {
    my ($self, $name, $code) = @_;
    push @{$self->hooks->{$name} ||= []}, $code;
}

sub emit_hook {
    my ($self, $name, @args) = @_;
    for my $code (@{$self->hooks->{$name}}) {
        $code->($self, @args);
    }
}

sub startup {}

sub request_class    { 'Kukuru::Request'    }
sub controller_class { 'Kukuru::Controller' }

sub app_controller_class { shift->meta->name."::Controller" }

__PACKAGE__->meta->make_immutable;
