use strict;
use warnings;
use utf8;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

{
    package MyApp;
    use File::Spec;
    use File::Basename qw(dirname);
    use Text::Xslate;
    use Test::More;
    use Mouse;
    BEGIN { extends 'Kukuru' };
    no Mouse;

    sub startup {
        my ($self) = @_;

        $self->router->get('/' => sub {
            my ($self) = @_;
            my $res;

            $res = $self->render(json => {test => 1});
            is $res->code, 200;
            is_deeply $res->body, ['{"test":1}'];

            $res = $self->render(json => {utf8 => "あいうえお"});
            is $res->code, 200;
            is_deeply $res->body, ['{"utf8":"\u3042\u3044\u3046\u3048\u304a"}'];

            $self->req->new_response(200, [], ['ok']);
        });
    }
}

my $app = eval { MyApp->to_psgi() };
ok !$@;

test_psgi
    app => $app,
    client => sub {
        my $cb = shift;
        my $res = $cb->(GET '/');
        is $res->code, 200;
    };

done_testing;
