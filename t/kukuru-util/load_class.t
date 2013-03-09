use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Util;

subtest 'load class' => sub {
    my $klass = Kukuru::Util::load_class('Kukuru');
    is $klass, 'Kukuru';
};

subtest 'load class with prefix' => sub {
    my $klass = Kukuru::Util::load_class('Response', 'Kukuru');
    is $klass, 'Kukuru::Response';
};

subtest 'load class with +' => sub {
    my $klass = Kukuru::Util::load_class('+Kukuru::Request', 'Hoge');
    is $klass, 'Kukuru::Request';
};

done_testing;
