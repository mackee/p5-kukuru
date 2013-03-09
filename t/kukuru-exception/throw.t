use strict;
use warnings;
use Test::More;
use Kukuru::Exception;

subtest 'throw' => sub {
    ok !$@;
    my $file = __FILE__;
    my $line = __LINE__;

    eval {
        Kukuru::Exception->throw(
            message => 'message',
            file    => $file,
            line    => $line,
        );
    };
    ok my $e = $@;
    is $e->message, 'message';
    is $e->file, $file;
    is $e->line, $line;
};

subtest 'stringify' => sub {
    my $file = __FILE__;
    my $line = __LINE__;

    eval {
        Kukuru::Exception->throw(
            message => 'message',
            file    => $file,
            line    => $line,
        );
    };
    ok my $e = $@;
    ok $e->stringify =~  m/message at (.+) line (\d+)\./;
    is $1, $file;
    is $2, $line;
};

done_testing;
