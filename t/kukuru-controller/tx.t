use strict;
use warnings;
use Test::More;
use Kukuru::Controller;

subtest 'has tx' => sub {
    eval {
        my $c = Kukuru::Controller->new(
            tx => 1,
        );
    };
    ok !$@;
};

subtest 'no tx' => sub {
    eval {
        my $c = Kukuru::Controller->new();
    };
    like $@, qr/Attribute \(tx\) is required/;
};

done_testing;
