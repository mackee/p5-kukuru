package MyApp;
use strict;
use warnings;
use Mouse;
BEGIN { extends 'Kukuru' }
no Mouse;

sub startup {
    my $self = shift;

    $self->router->get('/' => sub {
        my $c = shift; # MyApp::Controller

        my $text = $c->mobile_agent->is_docomo ? "is_docomo" : "isnt_docomo";
        $c->req->new_response(200, [], [$text]);
    });
}

__PACKAGE__->meta->make_immutable;
