use strict;
use warnings;
use Test::More;
use Kukuru::Request;

subtest 'new' => sub {
    my $req = Kukuru::Request->new({});
    isa_ok $req, 'Plack::Request';
};

subtest 'encoding' => sub {
    my $req = Kukuru::Request->new({});
    isa_ok $req->encoding, "Encode::utf8";
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
