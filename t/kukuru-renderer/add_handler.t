use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Renderer;

subtest 'add_handler' => sub {
    my $renderer = Kukuru::Renderer->new;
    ok !$renderer->handlers->{test};
    $renderer->add_handler('test' => sub {});

    isa_ok $renderer->handlers, 'HASH';
    isa_ok $renderer->handlers->{test}, 'CODE';
};

done_testing;
