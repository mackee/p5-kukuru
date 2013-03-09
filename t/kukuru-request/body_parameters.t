use strict;
use warnings;
use Test::More;
use Kukuru::Request;
use Hash::MultiValue;
use Encode;

subtest 'body_parameters' => sub {
    my $stuff = Hash::MultiValue->new(foo => encode_utf8 'あいうえお');
    my $req   = Kukuru::Request->new({'plack.request.body' => $stuff});

    ok !$req->env->{'kukuru.request.body'};
    my $params = $req->body_parameters;
    ok $req->env->{'kukuru.request.body'};

    is $params->{foo}, 'あいうえお';
    is_deeply $params, $req->env->{'kukuru.request.body'};
};

done_testing;
