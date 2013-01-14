package MyApp::Controller::User;
use strict;
use warnings;
use Kukuru::Lite;

get '/user' => sub {
    my ($self) = @_;
    $self->req->new_response(200, [], ['user']);
};

1;
