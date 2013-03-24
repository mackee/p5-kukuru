use strict;
use warnings;
use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use HTTP::Cookies;

{
    package MyApp;
    use Kukuru::Lite;

    get '/' => sub {
        my ($self) = @_;
        $self->flash("test" => "test");
        $self->redirect("/redirect");;
    };

    get '/redirect' => sub {
        my ($self) = @_;
        $self->render(text => $self->flash('test') || "not found flash");
    };

    get '/error' => sub {
        my ($self) = @_;
        $self->flash;
    };
}

my $app = builder {
    enable "Session";
    MyApp->app->to_psgi;
};

subtest 'set, get, no flash' => sub {
    test_psgi
        app => $app,
        client => sub {
            my ($cb) = @_;
            my $jar = HTTP::Cookies->new;

            note "set flash";
            my $res = $cb->(GET '/');

            note "get flash";
            $jar->extract_cookies($res);
            my $location = $res->headers->header('Location');
            my $req = GET $location;
            $jar->add_cookie_header($req);
            $res = $cb->($req);
            is $res->content, "test";
            $jar->extract_cookies($res);

            note "no flash";
            $req = GET $location;
            $jar->add_cookie_header($req);
            $res = $cb->($req);
            is $res->content, "not found flash";
        };
};

subtest 'set, get, no flash' => sub {
    test_psgi
        app => $app,
        client => sub {
            my ($cb) = @_;
            my $jar = HTTP::Cookies->new;

            my $res = $cb->(GET '/error');
            like $res->content, qr/need key for flash/;

        };
};

done_testing;
