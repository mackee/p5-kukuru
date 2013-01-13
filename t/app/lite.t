use strict;
use warnings;
use Test::More;
use Kukuru::Lite;
use Plack::Test;
use HTTP::Request::Common;

get '/' => sub {
    my $self = shift;
    $self->req->new_response(200);
};

my $app = app->to_psgi;

test_psgi
    app => $app,
    client => sub {
        my $cb  = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200;
    };


done_testing;
