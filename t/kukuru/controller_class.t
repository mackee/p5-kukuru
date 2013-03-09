use strict;
use warnings;
use Test::More;
use Kukuru;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';

    around controller_class => sub {
        "MyApp::Controller::Base";
    };
}

subtest 'default controller class' => sub {
   is +Kukuru->controller_class, 'Kukuru::Controller';
};

subtest 'override controller class' => sub {
   is +MyApp->controller_class, 'MyApp::Controller::Base';
};

done_testing;
