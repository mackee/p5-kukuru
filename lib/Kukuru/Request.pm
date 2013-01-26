package Kukuru::Request;
use strict;
use warnings;
use parent 'Plack::Request';
use Carp ();
use Encode;
use Kukuru::Response;

sub body_parameters {
    my ($self) = @_;
    $self->{'kukuru.body_parameters'} ||=
        $self->_decode_parameters($self->SUPER::body_parameters());
}

sub query_parameters {
    my ($self) = @_;
    $self->{'kukuru.query_parameters'} ||=
        $self->_decode_parameters($self->SUPER::query_parameters());
}

sub parameters {
    my $self = shift;

    $self->env->{'kukuru.request.merged'} ||= do {
        my $query = $self->query_parameters;
        my $body  = $self->body_parameters;

        Hash::MultiValue->new($query->flatten, $body->flatten);
    };
}

sub body_parameters_raw {
    shift->SUPER::body_parameters();
}

sub query_parameters_raw {
    shift->SUPER::query_parameters();
}

sub parameters_raw {
    my $self = shift;

    $self->env->{'plack.request.merged'} ||= do {
        my $query = $self->SUPER::query_parameters();
        my $body  = $self->SUPER::body_parameters();

        Hash::MultiValue->new($query->flatten, $body->flatten);
    };
}

sub param_raw {
    my $self = shift;

    return keys %{ $self->parameters_raw } if @_ == 0;

    my $key = shift;
    return $self->parameters_raw->{$key} unless wantarray;
    return $self->parameters_raw->get_all($key);
}

sub encoding_name {
    my ($self) = @_;
    $self->env->{'kukuru.request.encoding_name'} || 'utf-8';
}

sub encoding {
    my ($self) = @_;
    return $self->{encoding} if $self->{encoding};

    my $enc_name = $self->encoding_name;
    my $enc = Encode::find_encoding($enc_name)
        or Carp::croak("encoding '$enc_name' not found.");

    $self->{encoding} = $enc;
}

sub new_response { shift;Kukuru::Response->new(@_) }

sub _decode_parameters {
    my ($self, $stuff) = @_;
    my $encoding = $self->encoding;
    my @flatten = $stuff->flatten;
    my @decoded;

    while (my ($k, $v) = splice @flatten, 0, 2) {
        push @decoded, $encoding->decode($k), $encoding->decode($v);
    }

    return Hash::MultiValue->new(@decoded);
}

1;
