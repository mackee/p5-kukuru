use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Renderer;

subtest 'BUILD' => sub {
    my $renderer = Kukuru::Renderer->new;

    my @handlers = qw(tiffany text json data);
    isa_ok $renderer->handlers->{$_}, 'CODE', $_ for @handlers;
};

done_testing;
