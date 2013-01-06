use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

{
    package MyApp;
    use Mouse;
    BEGIN { extends 'Kukuru' };
    no Mouse;

    sub startup {
        my ($self) = @_;
        $self->router->get('/' => sub {
            my ($self) = @_;
            $self->req->new_response(200, [], ["ok"]);
        });
    }
}

test_psgi
    app => MyApp->to_psgi(),
    client => sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->content, "ok";
    };

done_testing;
