use strict;
use warnings;
use Test::More;
use Kukuru::Renderer;

subtest 'build_handler' => sub {
    my $r = Kukuru::Renderer->new;
    is $r->build_handler(template => 1), 'template';
    is $r->build_handler(json => 1), 'json';
    is $r->build_handler(file => 1), 'file';
    is $r->build_handler(data => 1), 'data';
};

subtest 'build_handler: defined' => sub {
    my $r = Kukuru::Renderer->new;
    is $r->build_handler(template => 0), 'template';
    is $r->build_handler(json => 0), 'json';
    is $r->build_handler(file => 0), 'file';
    is $r->build_handler(data => 0), 'data';
};

subtest 'build_handler with handler' => sub {
    my $r = Kukuru::Renderer->new;
    my $handler = $r->build_handler(
        json    => {},
        handler => 'user_handler1'
    );
    is $handler, 'user_handler1';
};

subtest 'build_handler with default_handler' => sub {
    my $r = Kukuru::Renderer->new;
    eval { $r->build_handler() };
    like $@, qr/No handler/;
};

done_testing;
