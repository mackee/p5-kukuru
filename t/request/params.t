use strict;
use warnings;
use utf8;
use Test::More;
use Plack::Test;
use Kukuru::Request;
use HTTP::Request::Common;
use Encode qw(encode_utf8);

my $app = sub {
    my $req = Kukuru::Request->new(shift);

    note 'post paramters';
    is_deeply $req->body_parameters, { foo => 'こんにちは' };
    is_deeply $req->body_parameters_raw, { foo => encode_utf8 'こんにちは' };
    is $req->content, 'foo=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    note 'get paramters';
    is_deeply $req->query_parameters, { hoge => 'こんにちは' };
    is_deeply $req->query_parameters_raw, { hoge => encode_utf8 'こんにちは' };
    is $req->content, 'foo=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    $req->new_response(200)->finalize;
};

test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(POST "/?hoge=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF", {
        foo => "こんにちは"
    });
    ok $res->is_success;
};

done_testing;
