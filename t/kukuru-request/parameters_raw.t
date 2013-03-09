use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Request;
use Hash::MultiValue;
use Encode;

subtest 'parameters_raw' => sub {
    my $stuff = Hash::MultiValue->new(foo => encode_utf8 'あいうえお');
    my $req   = Kukuru::Request->new({
        'plack.request.body'  => $stuff,
        'plack.request.query' => $stuff,
    });

    my $params = $req->parameters_raw;
    my @foo = $params->get_all('foo');

    is scalar(@foo), 2;
    is $foo[0], encode_utf8 'あいうえお';
};

done_testing;
