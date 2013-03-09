use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Controller;

{
    package MyApp::Controller::Root;
    use Mouse;
    extends 'Kukuru::Controller';

    package MyApp;
    use Mouse;
    extends 'Kukuru';
}

sub tx {
    my $req = Kukuru::Request->new({
        HTTP_HOST   => 'localhost',
    });

    Kukuru::Transaction->new(
        app   => MyApp->new(),
        req   => $req,
        match => {},
    );
}

subtest 'args is ArrayRef' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());
    is $c->uri_with([test => 1]), "http://localhost/?test=1";
    is $c->uri_with([test => 1, test => 2]), "http://localhost/?test=1&test=2";
};

subtest 'args is text string' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());
    is $c->uri_with([test => 'あいうえお']), "http://localhost/?test=%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A";
};

done_testing;
