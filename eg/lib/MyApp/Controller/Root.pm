package MyApp::Controller::Root;
use strict;
use warnings;
use Kukuru::Lite;

get '/' => sub {
    my ($self) = @_;
    $self->req->new_response(200, [], ['ok']);
};

1;
