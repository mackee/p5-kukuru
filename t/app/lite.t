use strict;
use warnings;
use Test::More;
use Kukuru::Lite;
use Plack::Test;
use HTTP::Request::Common;

isa_ok __PACKAGE__, 'Kukuru';
isa_ok app(),       'Kukuru';

get '/' => sub {
    my $self = shift;

    isa_ok $self, 'Kukuru::Controller';
    isa_ok $self, 'main::Controller';

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
