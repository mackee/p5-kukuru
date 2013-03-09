use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';

    sub ping_opts { shift->{'Kukuru::Plugin::Web::Ping'}{options} }

    package Kukuru::Plugin::Web::Ping;
    use strict;
    use warnings;
    use Test::More;

    sub init {
        my ($class, $app, $opts) = @_;
        $app->{'Kukuru::Plugin::Web::Ping'}{options} = $opts;

        $app->router->get('/ping' => sub {
            my ($c) = @_;
            $c->render(text => 'pong');
        });
    }
}

subtest 'load_plugin' => sub {
    my $app = MyApp->new;

    ok !@{$app->router->routes};
    ok !$app->ping_opts;
    $app->load_plugin('Web::Ping');
    ok @{$app->router->routes};
    is_deeply $app->ping_opts, {};
};

subtest 'load_plugin with +' => sub {
    my $app = MyApp->new;

    ok !@{$app->router->routes};
    ok !$app->ping_opts;
    $app->load_plugin('+Kukuru::Plugin::Web::Ping');
    ok @{$app->router->routes};
    is_deeply $app->ping_opts, {};
};

subtest 'load_plugin with options' => sub {
    my $app = MyApp->new;

    ok !@{$app->router->routes};
    ok !$app->ping_opts;

    $app->load_plugin('+Kukuru::Plugin::Web::Ping' => {text => 'ok'});
    ok @{$app->router->routes};
    ok $app->ping_opts;
};

done_testing;
