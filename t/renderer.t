use strict;
use warnings;
use Test::More;
use Kukuru::Renderer;

subtest 'build_handler: default handlers' => sub {
    my $r = Kukuru::Renderer->new;
    is $r->build_handler(template => 1), 'tiffany';
    is $r->build_handler(json => 1), 'json';
    is $r->build_handler(file => 1), 'file';
    is $r->build_handler(data => 1), 'data';
};

subtest 'build_handler: user handler' => sub {
    my $r = Kukuru::Renderer->new;
    my $handler = $r->build_handler(
        json    => {},
        handler => 'user_handler1'
    );
    is $handler, 'user_handler1';
};

subtest 'build_handler: default handler' => sub {
    my $r = Kukuru::Renderer->new;
    my $handler = $r->build_handler();
    is $handler, 'tiffany';
};

done_testing;
