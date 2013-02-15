use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Text::Xslate;

{
    package MyApp;
    use Mouse;
    BEGIN { extends 'Kukuru' };
    no Mouse;
    use File::Spec;
    use File::Basename qw(dirname);
    use Test::More;

    sub startup {
        my ($self) = @_;

        $self->template_engine(Text::Xslate->new(
            path => [File::Spec->catdir(dirname(__FILE__))],
        ));

        $self->router->get('/' => sub {
            my ($self) = @_;
            my $res;

            $res = $self->render('template.tx');
            is $res->code, 200;
            is_deeply $res->body, ["hoge\n"];

            $res = $self->render(template => 'template.tx');
            is $res->code, 200;
            is_deeply $res->body, ["hoge\n"];

            $res = $self->render('template.tx',
                status => 404,
                foo    => 1,
            );
            is $res->code, 404;
            is_deeply $res->body, ["hoge1\n"];

            $res = $self->render(template => 'template.tx',
                status => 404,
                foo    => 1,
            );
            is $res->code, 404;
            is_deeply $res->body, ["hoge1\n"];

            eval { $self->render(test => 1) }; # template
            like $@, qr/Template name is not given/;

            eval { $self->render(test => 1, handler => 'test') };
            like $@, qr/No handler for "test" available./;

            $self->req->new_response(200, [], ['ok']);
        });
    }

    # sub template_engine { ... }
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
