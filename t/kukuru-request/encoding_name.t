use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Request;

subtest 'encoding_name: default' => sub {
    my $req = Kukuru::Request->new({});
    is $req->encoding_name, "utf-8";
};

subtest 'encoding_name: shift_jis' => sub {
    my $req = Kukuru::Request->new({'kukuru.request.encoding_name' => 'shift_jis'});
    is $req->encoding_name, "shift_jis";
};

done_testing;
