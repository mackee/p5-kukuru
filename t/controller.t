use strict;
use warnings;
use Test::More;
use Kukuru::Controller;
use Kukuru::Request;

subtest 'uri_for, uri_with, redirect' => sub {
    my $c = Kukuru::Controller->new(
        app => 1,
        req => Kukuru::Request->new({
            PATH_INFO => '/',
            HTTP_HOST => 'localhost'
        }),
    );
    is $c->uri_for('/'), 'http://localhost/';
    is $c->uri_for('/', [test => 1, test => 2]), 'http://localhost/?test=1&test=2';
    is $c->uri_with([test => 1, test => 2]), 'http://localhost/?test=1&test=2';
    isa_ok $c->redirect('/'), 'Kukuru::Response';

    my $res = $c->redirect('/', 301);
    is_deeply $res->finalize, [301, ['Location' => 'http://localhost/'], []];

    $res = $c->redirect([test => 1, test => 2], 301);
    is_deeply $res->finalize, [301, ['Location' => 'http://localhost/?test=1&test=2'], []];
};

subtest 'dispatch: action is coderef' => sub {
    my $match = {action => sub { return "matched" }};

    my $c = Kukuru::Controller->new(
        app => 1,
        req => 2,
    );
    is $c->dispatch($match), "matched";
};

subtest 'dispatch: action is arrayref' => sub {
    my $match = {action => [
        {action => sub {}},
        {action => sub {"matched"}},
        {action => sub {"no matched"}},
    ]};

    my $c = Kukuru::Controller->new(
        app => 1,
        req => 2,
    );
    is $c->dispatch($match), "matched";
};

subtest 'dispatch: action is string' => sub {
    my $match = {action => 'index'};

    my $c = Kukuru::Controller->new(
        app => 1,
        req => 2,
    );
    eval { $c->dispatch($match) }; # indexを実行しようとする
    like $@, qr/Can't locate object method "index" via package "Kukuru::Controller"/;
};

subtest 'dispatch: not match' => sub {
    my $match;

    my $c = Kukuru::Controller->new(
        app => 1,
        req => Kukuru::Request->new({}),
    );
    isa_ok $c->dispatch($match), "Kukuru::Response"; # indexを実行しようとする
};

done_testing;
