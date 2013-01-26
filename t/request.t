use strict;
use warnings;
use Test::More;
use Kukuru::Request;

subtest 'new' => sub {
    my $req = Kukuru::Request->new({});
    isa_ok $req, 'Plack::Request';
};

subtest 'encoding_name is default' => sub {
    my $req = Kukuru::Request->new({});
    is $req->encoding_name, 'utf-8';
};

subtest 'encoding_name is shift_jis' => sub {
    my $req = Kukuru::Request->new({
        'kukuru.request.encoding_name' => 'shift_jis',
    });
    is $req->encoding_name, 'shift_jis';
};

subtest 'utf-8 encoding' => sub {
    my $req = Kukuru::Request->new({});
    isa_ok $req->encoding, "Encode::utf8";
};

subtest 'encoding is not found' => sub {
    my $req = Kukuru::Request->new({
        'kukuru.request.encoding_name' => 'hisaichi5518',
    });
    eval { $req->encoding };
    like $@, qr/encoding 'hisaichi5518' not found/;
};

subtest 'new_response' => sub {
    my $req = Kukuru::Request->new({});
    my $res = $req->new_response(200);

    isa_ok $res, 'Kukuru::Response';
    is $res->code, 200;
};

subtest 'error' => sub {
    eval { Kukuru::Request->new };
    like $@, qr/\$env is required/;
};

done_testing;
