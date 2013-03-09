use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Request;
use Hash::MultiValue;
use Encode;

subtest 'query_parameters' => sub {
    my $stuff = Hash::MultiValue->new(foo => encode_utf8 'あいうえお');
    my $req   = Kukuru::Request->new({'plack.request.query' => $stuff});

    ok !$req->env->{'kukuru.request.query'};
    my $params = $req->query_parameters;
    ok $req->env->{'kukuru.request.query'};

    is $params->{foo}, 'あいうえお';
    is_deeply $params, $req->env->{'kukuru.request.query'};
};

done_testing;
