use strict;
use warnings;
use Test::More;
use Kukuru::Lite;

subtest 'add hook' => sub {
    is scalar(keys %{app->hooks || {}}), 0;

    hook 'test' => sub {};

    is scalar(keys %{app->hooks || {}}), 1;
};

done_testing;
