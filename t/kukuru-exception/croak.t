use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Exception;

subtest 'croak' => sub {
    eval { Kukuru::Exception->croak("test") }; my $line = __LINE__;

    ok my $e = $@;
    is $e->message, "test";
    is $e->file, __FILE__;
    is $e->line, $line;
};

done_testing;
