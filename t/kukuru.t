use strict;
use warnings;
use Test::More;
use Kukuru;

subtest 'new' => sub {
    my $app = Kukuru->new(helpers => {test => sub { "test" }});
    eval { $app->app_controller_class->test };
    ok !$@;
};

subtest 'select_controller_class' => sub {
    my $app = Kukuru->new;
    eval { $app->select_controller_class({controller => 'Root'}) };
    like $@, qr/Could not load class \(Kukuru::Controller::Root\)/;
};

done_testing;
