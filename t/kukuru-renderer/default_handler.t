use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Renderer;

subtest 'default_handler' => sub {
    my $renderer = Kukuru::Renderer->new;

    is $renderer->default_handler, 'tiffany';
};

done_testing;
