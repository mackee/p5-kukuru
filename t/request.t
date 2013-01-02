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
    isa_ok $req->new_response(200), 'Kukuru::Response';
};


subtest 'error' => sub {
    eval { Kukuru::Request->new };
    like $@, qr/\$env is required/;
};

done_testing;
