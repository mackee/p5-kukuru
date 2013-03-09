use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::Request;
use Hash::MultiValue;

subtest 'parameters' => sub {
    my $stuff = Hash::MultiValue->new(foo => 'あいうえお');
    my $req   = Kukuru::Request->new({
        'kukuru.request.body'  => $stuff,
        'kukuru.request.query' => $stuff,
    });

    my $params = $req->parameters;
    my @foo = $params->get_all('foo');

    is scalar(@foo), 2;
    is $foo[0], 'あいうえお';
};

done_testing;
