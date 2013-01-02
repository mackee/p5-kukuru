use strict;
use warnings;
use Test::More;
use Kukuru::Util;

subtest 'load Kukuru' => sub {
    my $klass = Kukuru::Util::load_class('Kukuru');
    is $klass, 'Kukuru';
};

subtest 'load Kukuru::Response, use prefix' => sub {
    my $klass = Kukuru::Util::load_class('Response', 'Kukuru');
    is $klass, 'Kukuru::Response';
};

subtest 'load Kukuru::Request' => sub {
    my $klass = Kukuru::Util::load_class('+Kukuru::Request', 'Hoge');
    is $klass, 'Kukuru::Request';
};

done_testing;
