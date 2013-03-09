use strict;
use warnings;
use Test::More;
use Kukuru::Lite;

{
    package MyApp::Plugin::Test;

    sub init {
        my ($class, $app, @args) = @_;
        $app->{loaded_plguin}++;
    }
}

subtest 'add plugin' => sub {
    ok !app->{loaded_plguin};

    plugin "+MyApp::Plugin::Test";

    ok app->{loaded_plguin};
};

done_testing;
