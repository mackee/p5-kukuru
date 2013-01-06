use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    BEGIN { extends 'Kukuru' };
    no Mouse;

    sub startup {
        my ($self) = @_;
        $self->router->get('/' => 'Root#index');
    }

    package MyApp::Controller::Root;
    use Mouse;
    BEGIN { extends 'Kukuru::Controller' };
    no Mouse;
}

eval { MyApp->new };
like $@, qr/extend "MyApp::Controller"/;

done_testing;
