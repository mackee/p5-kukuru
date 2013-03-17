use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Renderer;

subtest 'handlers' => sub {
    my $renderer = Kukuru::Renderer->new;
    isa_ok $renderer->handlers, 'HASH';
};

done_testing;
