use strict;
use warnings;
use Test::More;
use Kukuru;

subtest 'exception_class' => sub {
    is +Kukuru->exception_class, "Kukuru::Exception";
};

done_testing;
