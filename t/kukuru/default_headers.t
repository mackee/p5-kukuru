use strict;
use warnings;
use Test::More;
use Plack::Util;

{
    package MyApp;
    use Mouse;
    extends "Kukuru";
}

subtest 'default_headers' => sub {
    my $app = MyApp->new;
    my $headers = $app->default_headers;
    my $h = Plack::Util::headers($headers);

    is $h->get("X-XSS-Protection"), "1; mode=block";
    is $h->get("X-Frame-Options"), "SAMEORIGIN";
    is $h->get("X-Content-Type-Options"), "nosniff";
};

done_testing;
