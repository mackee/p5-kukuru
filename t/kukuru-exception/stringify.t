use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Exception;

subtest 'stringify' => sub {
    eval {
        Kukuru::Exception->throw(message => "test");
    };

    ok my $e = $@;
    is "$e", "test";
};

subtest 'stringify' => sub {
    eval {
        Kukuru::Exception->throw(
            message => "test",
            file => __FILE__,
            line => 10,
        );
    };

    my $file = __FILE__;
    ok my $e = $@;
    like "$e", qr/test at $file line 10./;
};

done_testing;
