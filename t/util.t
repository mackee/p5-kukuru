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

subtest 'find_content_type: dont have charset' => sub {
    is +Kukuru::Util::find_content_type(
        format => 'html',
    ), "text/html";
};

subtest 'find_content_type: have charset' => sub {
    is +Kukuru::Util::find_content_type(
        format  => 'html',
        charset => 'UTF-8',
    ), "text/html; charset=UTF-8";
};

subtest 'find_content_type: dont have format' => sub {
    eval { Kukuru::Util::find_content_type() };
    ok $@;
    like $@, qr/require format/;
};


done_testing;
