use strict;
use warnings;
use utf8;
use Test::More;
use Hash::MultiValue;
use Kukuru::Request;
use Encode;

subtest 'decode params: default' => sub {
    my $req = Kukuru::Request->new({});

    my $stuff  = Hash::MultiValue->new("foo" => encode_utf8 "あいうえお");
    my $params = $req->_decode_parameters($stuff);

    isa_ok $params, 'Hash::MultiValue';
    is $params->{foo},'あいうえお';
};

subtest 'decode params: shift_jis' => sub {
    my $req = Kukuru::Request->new({
        'kukuru.request.encoding_name' => 'Shift_JIS'
    });

    my $stuff  = Hash::MultiValue->new("foo" => encode('Shift_JIS', "あいうえお"));
    my $params = $req->_decode_parameters($stuff);

    isa_ok $params, 'Hash::MultiValue';
    is encode('Shift_JIS', $params->{foo}), encode('Shift_JIS', 'あいうえお');
};

done_testing;
