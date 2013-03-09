use strict;
use warnings;
use Test::More;
use Kukuru::Request;
use Kukuru::Transaction;

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

        return;
    }

    sub return_1 {
        my ($self) = @_;
        $self->tx->{run_controller}++;

        return 1;
    }
}

sub tx {
    my $req = Kukuru::Request->new({});

    Kukuru::Transaction->new(
        app   => MyApp->new,
        req   => $req,
        match => {},
    );
}

subtest '_dispatch: {controller => Str, action => Str}' => sub {
    my $tx = tx();

    is $tx->{run_controller}, undef;
    $tx->_dispatch({
        controller => 'Root',
        action     => 'index',
    });
    is $tx->{run_controller}, 1;
};

subtest '_dispatch: action is ArrayRef' => sub {
    my $tx = tx();

    is $tx->{run_controller}, undef;
    $tx->_dispatch({
        action => [
            {controller => 'Root', action => 'index'},
            {controller => 'Root', action => 'index'},
            {controller => 'Root', action => 'return_1'},
            {controller => 'Root', action => 'index'},
        ],
    });
    is $tx->{run_controller}, 3;
};

done_testing;
