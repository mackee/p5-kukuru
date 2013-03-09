use strict;
use warnings;
use Test::More;

use Kukuru::Lite;

subtest 'app isa __PACKAGE__' => sub {
    isa_ok app, __PACKAGE__;
};

done_testing;
