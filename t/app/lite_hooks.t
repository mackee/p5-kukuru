use strict;
use warnings;
use Test::More;
use Kukuru::Lite;
use Plack::Test;
use HTTP::Request::Common;

isa_ok __PACKAGE__, 'Kukuru';
isa_ok app(),       'Kukuru';

hook 'test' => sub {
    my $self = shift;
    $self->{emited_hook}++;
};

get '/' => sub {
    my $self = shift;

    ok !$self->app->{emited_hook};
    ok !app->{emited_hook};
    app->emit_hook('test');

    is $self->app->{emited_hook}, 1;
    is app->{emited_hook}, 1;

    $self->req->new_response(200);
};

my $app = app->to_psgi;

test_psgi
    app => $app,
    client => sub {
        my $cb  = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200;
        # diag explain $res;
    };

done_testing;
