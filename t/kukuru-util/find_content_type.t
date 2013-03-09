use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Util;

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
