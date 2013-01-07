package Kukuru::Controller;
use strict;
use warnings;

use Mouse;

has [qw(app req)] => (
    is => 'rw',
    required => 1,
);

has match => (
    is => 'rw',
);

no Mouse;

# TODO: render_*
# render_template, render_action, render_file, render_data, render_text
sub render {}

sub redirect {
    my ($self, $uri, $status) = @_;

    if (ref $uri eq 'ARRAY') {
        $uri = $self->uri_with($uri);
    }
    elsif ($uri =~ m/^\//) {
        $uri = $self->uri_for($uri);
    }

    $self->req->new_response(
        $status || 302,
        ['Location' => "$uri"],
        [],
    );
}

sub uri_for {
    my ($self, $path, $params) = @_;
    my $uri = $self->req->base;
    $path = $uri->path eq '/' ? $path : $uri->path.$path;

    $uri->path($path);
    my $enc = $self->req->encoding;
    $uri->query_form(map { $enc->encode($_) } @$params) if $params;

    return $uri;
}

sub uri_with {
    my ($self, $params) = @_;
    my $uri = $self->req->uri;

    my $enc = $self->req->encoding;
    $uri->query_form(map { $enc->encode($_) } @$params) if $params;

    return $uri;
}

sub param     { shift->req->param(@_)     }
sub param_raw { shift->req->param_raw(@_) }
sub session   { shift->req->session(@_)   }
sub flash     {} # $self->dispatchであれこれする必要ある

sub dispatch { # たぶん、render_actionに名前変える
    my ($self, $match) = @_;

    if ($match) {
        my $action = $match->{action};

        if (ref $action eq 'ARRAY') {
            for my $args (@$action) {
                my $res = $self->dispatch($args);
                return $res if $res;
            }
        }
        elsif (ref $action eq 'CODE') {
            $action->($self);
        }
        else {
            $self->$action();
        }
    }
    else {
        $self->req->new_response(404, [], ['Not Found Page']);
    }
}

__PACKAGE__->meta->make_immutable;
