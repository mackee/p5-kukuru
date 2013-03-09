use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Request;

subtest 'encoding: default' => sub {
    my $req = Kukuru::Request->new({});
    isa_ok $req->encoding, "Encode::utf8";
};

subtest 'encoding: shift_jis' => sub {
    my $req = Kukuru::Request->new({'kukuru.request.encoding_name' => 'shift_jis'});
    isa_ok $req->encoding, "Encode::XS";
};

subtest 'encoding: hisaichi5518' => sub {
    my $req = Kukuru::Request->new({'kukuru.request.encoding_name' => 'hisaichi5518'});
    eval { $req->encoding };
    like $@, qr/encoding 'hisaichi5518' not found/;
};

done_testing;
