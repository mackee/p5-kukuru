use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Request;
use Hash::MultiValue;
use Encode;

subtest 'query_parameters_raw' => sub {
    my $stuff = Hash::MultiValue->new(foo => encode_utf8 'あいうえお');
    my $req   = Kukuru::Request->new({'plack.request.query' => $stuff});

    my $params = $req->query_parameters_raw;
    is $params->{foo}, encode_utf8 'あいうえお';
};

done_testing;
