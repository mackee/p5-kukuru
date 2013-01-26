package MyApp;
use strict;
use warnings;

use Module::Find qw(useall);
use Mouse;
BEGIN { extends 'Kukuru' }
no Mouse;

sub startup {
    my $self = shift;

    $self->router->load_routes(useall 'MyApp::Controller');
}

__PACKAGE__->meta->make_immutable;
