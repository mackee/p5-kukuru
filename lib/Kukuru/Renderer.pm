package Kukuru::Renderer;
use strict;
use warnings;
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

    $self->add_handler(tiffany => \&_tiffany);

    # TODO
    # $self->add_handler(json => \&_json);
    $self->add_handler(text => \&_text);
    # $self->add_handler(data => \&_data);
    # $self->add_handler(action => \&_action);
}

sub add_handler {
    my ($self, $name, $code) = @_;

    # TODO: 既に存在していたら警告orエラー
    $self->handlers->{$name} = $code;
}

sub render {
    my ($self, $c, $output, %vars) = @_;

    $vars{handler} ||= $self->build_handler(%vars);
    if (my $code = $self->handlers->{$vars{handler}}) {
        return $code->($c, $output, %vars);
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
