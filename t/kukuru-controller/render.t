use strict;
use warnings;
use Test::More;

{
    package MyApp::Controller::Root;
    use Mouse;
    extends 'Kukuru::Controller';

    package MyApp;
    use Mouse;
    extends 'Kukuru';

    sub startup {
        my $self = shift;
        $self->response_builder->add_handler(template => sub {
            my $c = shift;
            +{@_}
        });
    }
}

sub tx {
    my $req = Kukuru::Request->new({
        HTTP_HOST   => 'localhost',
    });

    Kukuru::Transaction->new(
        app   => MyApp->new(),
        req   => $req,
        match => {},
    );
}

subtest 'with template' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    my $args =  $c->render(template => 'root/index');
    is $args->{template}, 'root/index';
    is $args->{handler}, 'template';
};

subtest 'only path' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    my $args =  $c->render('root/index');
    is $args->{template}, 'root/index';
    is $args->{handler}, 'template';
};

subtest 'path with vars' => sub {
    my $c = MyApp::Controller::Root->new(tx => tx());

    my $args =  $c->render('root/index', test => 1);
    is $args->{test}, 1;
};

done_testing;
