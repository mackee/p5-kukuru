use strict;
use warnings;
use Test::More;
use Kukuru::Lite;
use Plack::Test;
use HTTP::Request::Common;

{
    package Kukuru::Plugin::Foo;
    use strict;
    use warnings;
    use Test::More;
    sub init {
        my ($class, $app, @args) = @_;

        is $class, 'Kukuru::Plugin::Foo';
        isa_ok $app, 'main';
        is scalar(@args), 1;
        is_deeply $args[0], {test => 1};
    };
}

plugin 'Foo' => {test => 1};

get '/' => sub {
    my $self = shift;

    isa_ok $self, 'Kukuru::Controller';

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
