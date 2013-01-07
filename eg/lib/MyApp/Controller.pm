package MyApp::Controller;
use strict;
use warnings;

use HTTP::MobileAgent;
use Mouse;
BEGIN { extends 'Kukuru::Controller' };

has mobile_agent => (
    is => 'rw',
    default => sub {
        my $self = shift;
        HTTP::MobileAgent->new($self->req->env);
    },
    lazy => 1,
);

no Mouse;

__PACKAGE__->meta->make_immutable;
