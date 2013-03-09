use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';
}

subtest 'emit hook' => sub {
    my $app = MyApp->new;
    my $count;
    $app->add_hook(test => sub {$count++});
    $app->add_hook(test => sub {$count++});

    $app->emit_hook('test');
    is $count, 2;

    $app->emit_hook('test');
    is $count, 4;
};

subtest 'emit hook with args' => sub {
    my $app = MyApp->new;
    my $count;
    $app->add_hook(test => sub {
        my ($app, @args) = @_;
        $count = $args[0];
    });

    $app->emit_hook('test', 1);
    is $count, 1;

    $app->emit_hook('test', 2);
    is $count, 2;
};

done_testing;
