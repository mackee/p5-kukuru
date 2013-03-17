package Kukuru::Renderer;
use strict;
use warnings;

use Kukuru::Renderer::Template;
use Kukuru::Renderer::Text;
use Kukuru::Renderer::JSON;
use Kukuru::Renderer::Data;

use Mouse;
use Carp ();

has handlers => (
    is => 'rw',
    default => sub { +{} },
);

no Mouse;

sub BUILD {
    my ($self) = @_;

    $self->add_handler(template => \&Kukuru::Renderer::Template::handler);
    $self->add_handler(text     => \&Kukuru::Renderer::Text::handler);
    $self->add_handler(json     => \&Kukuru::Renderer::JSON::handler);
    $self->add_handler(data     => \&Kukuru::Renderer::Data::handler);
}

sub add_handler {
    my ($self, $name, $code) = @_;

    $self->handlers->{$name} = $code;
}

sub render {
    my ($self, $c, %vars) = @_;

    $vars{handler} ||= $self->build_handler(%vars);
    if (my $code = $self->handlers->{$vars{handler}}) {
        $code->($c, %vars);
    }
    else {
        Carp::croak(qq!No handler for "$vars{handler}" available.!);
    }
}

sub build_handler {
    my ($self, %vars) = @_;
    return $vars{handler} if $vars{handler};

    my $handler = $vars{template} ? 'template' :
                  $vars{json}     ? 'json'     :
                  $vars{text}     ? 'text'     :
                  $vars{file}     ? 'file'     :
                  $vars{data}     ? 'data'     : undef;

    if (!$handler) {
        Carp::croak("No handler.");
    }

    return $handler;
}

__PACKAGE__->meta->make_immutable;
