use strict;
use warnings;
use utf8;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

{
    package MyApp;
    use Test::More;
    use Mouse;
    BEGIN { extends 'Kukuru' };
    no Mouse;
    use File::Spec;

    sub startup {
        my ($self) = @_;

        $self->router->get('/format' => sub {
            my ($self) = @_;
            open my $fh, '<', File::Spec->catfile('lib/Kukuru.pm') or fail $!;
            $self->render(data => $fh, format => ".pm");
        });
        $self->router->get('/type' => sub {
            my ($self) = @_;
            open my $fh, '<', File::Spec->catfile('lib/Kukuru.pm') or fail $!;
            $self->render(data => $fh, type => "text/plain; charset=utf-8");
        });
        $self->router->get('/dont_have_content_type' => sub {
            my ($self) = @_;
            open my $fh, '<', File::Spec->catfile('lib/Kukuru.pm') or fail $!;
            $self->render(data => $fh);
        });
    }
}

my $app = eval { MyApp->to_psgi() };
ok !$@;

test_psgi
    app => $app,
    client => sub {
        my $cb = shift;
        my $res;

        $res = $cb->(GET '/format');
        is $res->code, 200;
        like $res->content, qr/package Kukuru/;

        $res = $cb->(GET '/type');
        is $res->code, 200;
        like $res->content, qr/package Kukuru/;
        is $res->header('Content-Type'), "text/plain; charset=utf-8";

        $res = $cb->(GET '/dont_have_content_type');
        is $res->code, 500;
    };

done_testing;
