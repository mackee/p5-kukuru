package Kukuru::Test;
use strict;
use warnings;
use parent "Exporter";
use Carp;
use Plack::Test;

our @EXPORT = qw(test_app);

sub test_app {
    my (%args) = @_;
    my $app      = $args{app}    or croak 'app needed';
    my $client   = $args{client} or croak 'client test code needed';
    my $impl     = $args{impl};
    my $app_name = ref $app;

    my $tx;
    if (!$app->{__added_hook_for_test}) {
        unshift @{$app->hooks->{after_build_tx} ||= []}, sub {
            $tx = $_[1];
        };

        $app->{__added_hook_for_test}++;
    }

    $args{client} = sub {
        my $callback = shift;
        my $cb = sub {
            my $req = shift;
            my $res = $callback->($req);

            return ($res, $tx);
        };

        $client->($cb)
    };

    local $Plack::Test::Impl = $impl if $impl;
    test_psgi(
        %args,
        app => $app->to_psgi,
    );
}

1;
