use strict;
use warnings;
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
    has '+template_engine' => (
        default => sub {
            Text::Xslate->new(
                path => [File::Spec->catdir(dirname(__FILE__))],
            );
        },
    );

    no Mouse;

    sub startup {
        my ($self) = @_;

        $self->router->get('/' => sub {
            my ($self) = @_;
            my $res;

            $res = $self->render(text => 'ok');
            is $res->code, 200;
            is_deeply $res->body, ["ok"];

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
