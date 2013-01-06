package Kukuru::Controller;
use strict;
use warnings;

use Carp ();
use Plack::MIME;
use Mouse;

has [qw(app req)] => (
    is => 'rw',
    required => 1,
);

has match => (
    is => 'rw',
);

no Mouse;

sub dispatch {
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
