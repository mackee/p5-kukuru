use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';

    package MyApp::Controller::Root;
    use Mouse;
    extends 'Kukuru::Controller';

    sub index {
        my ($self) = @_;
        $self->tx->{run_controller}++;
    }
}

sub tx {
    my $req = Kukuru::Request->new({});

    Kukuru::Transaction->new(
        app   => MyApp->new,
        req   => $req,
        match => {
            controller => 'Root',
            action     => 'index',
        },
    );
}

subtest 'dispatch: {controller => Str, action => Str}' => sub {
    my $tx = tx();

    is $tx->{run_controller}, undef;
    $tx->dispatch;
    is $tx->{run_controller}, 1;
};

done_testing;
