use strict;
use warnings;
use Test::More;
use Kukuru::Controller;
use Kukuru::Request;
use Kukuru::Transaction;

{
    package MyApp::Controller::Root;
    use Mouse;
    extends 'Kukuru::Controller';

    sub index {
        my ($self) = @_;
        $self->{run_action}++;
        $self->{package} = ref $self;
    }

    package MyApp;
    use Mouse;
    extends 'Kukuru';
}

sub tx {
    my $req = Kukuru::Request->new({});

    Kukuru::Transaction->new(
        app   => MyApp->new(),
        req   => $req,
        match => {},
    );
}

subtest 'action is CodeRef' => sub {
    my $c = Kukuru::Controller->new(tx => tx());
    my $count;

    ok !$count;
    $c->dispatch({action => sub {
        my ($self) = @_;
        $count++;
        isa_ok $self, 'Kukuru::Controller';
    }});
    is $count, 1;
};

subtest 'action is String' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    $c->dispatch({action => 'index'});
    is $c->{run_action}, 1;
    is $c->{package}, "MyApp::Controller::Root";
};

subtest 'action is String' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    $c->dispatch({action => 'index'});
    is $c->{run_action}, 1;
    is $c->{package}, "MyApp::Controller::Root";
};

subtest 'action is String, but not_found action' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    my $res = $c->dispatch({action => 'not_found'});
    is $res->content->[0], "Not Found Action(not_found)";
};

subtest 'action is empty' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    my $res = $c->dispatch({});
    is $res->content->[0], "Not Found Page";
};

subtest 'no match' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    my $res = $c->dispatch();
    is $res->content->[0], "Not Found Page";
};

done_testing;
