use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';
}


my $app = MyApp->new;
$app->router->get('/' => sub {
    my $c = shift;
    $c->render(text => 'ok');
});

test_psgi
    app => $app->to_psgi,
    client => sub {
        my $cb = shift;
        my $res = $cb->(GET '/');

        is $res->content, 'ok';
    };



done_testing;
