use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';
}

{
    package MyApp::Deep::Deep::DeepDeep::Deep;
    use Mouse;
    extends 'Kukuru';
}

subtest 'app_controller_class' => sub {
    my $class = "MyApp";
    my $app   = $class->new;

    is $app->app_controller_class, "$class\::Controller";
};

subtest 'app_controller_class' => sub {
    my $class = "MyApp::Deep::Deep::DeepDeep::Deep";
    my $app   = $class->new;

    is $app->app_controller_class, "$class\::Controller";
};

done_testing;
