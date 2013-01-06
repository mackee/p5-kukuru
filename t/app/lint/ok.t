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

    package MyApp::Controller;
    use Mouse;
    BEGIN { extends 'Kukuru::Controller' };
    no Mouse;

    package MyApp::Controller::Root;
    use Mouse;
    BEGIN { extends 'MyApp::Controller' };
    no Mouse;

    sub index {}
}

eval { MyApp->new };
ok !$@;

done_testing;
