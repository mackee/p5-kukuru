use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';
}

subtest 'add hook' => sub {
    my $app = MyApp->new;

    is scalar(@{$app->hooks->{hook} || []}), 0;

    $app->add_hook(hook => sub {});

    is scalar(@{$app->hooks->{hook} || []}), 1;

    $app->add_hook(hook => sub {});

    is scalar(@{$app->hooks->{hook} || []}), 2;
};

done_testing;
