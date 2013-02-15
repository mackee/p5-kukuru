package Kukuru::Renderer;
use strict;
use warnings;

use Kukuru::Renderer::Handler::Tiffany;
use Kukuru::Renderer::Handler::Text;
use Kukuru::Renderer::Handler::JSON;
use Kukuru::Renderer::Handler::Data;

use Mouse;
use Carp ();

has handlers => (
    is => 'rw',
    default => sub { +{} },
);

has default_handler => (
    is => 'rw',
    default => 'tiffany',
);

no Mouse;

sub BUILD {
    my ($self) = @_;

    $self->add_handler(tiffany => \&Kukuru::Renderer::Handler::Tiffany::handler);
    $self->add_handler(text    => \&Kukuru::Renderer::Handler::Text::handler);
    $self->add_handler(json    => \&Kukuru::Renderer::Handler::JSON::handler);
    $self->add_handler(data    => \&Kukuru::Renderer::Handler::Data::handler);

    # TODO
    # $self->add_handler(action => \&_action);
}

sub add_handler {
    my ($self, $name, $code) = @_;

    # TODO: 既に存在していたら警告orエラー
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

    my $handler = $vars{json} ? 'json' :
                  $vars{text} ? 'text' :
                  $vars{file} ? 'file' :
                  $vars{data} ? 'data' : undef;

    return $handler || $self->default_handler;
}

sub _tiffany {
    my ($c, $output, %vars) = @_;
    my $template = $vars{template};

    $$output = $c->app->template_engine->render($template, {c => $c, %vars});
}

sub _text {
    my ($c, $output, %vars) = @_;
    $$output = $vars{text};
}

__PACKAGE__->meta->make_immutable;
