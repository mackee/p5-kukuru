use strict;
use warnings;
use Test::More;
use Kukuru;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';

    around request_class => sub {
        "MyApp::Request";
    };
}

subtest 'default request class' => sub {
   is +Kukuru->request_class, 'Kukuru::Request';
};

subtest 'override request class' => sub {
   is +MyApp->request_class, 'MyApp::Request';
};

done_testing;
