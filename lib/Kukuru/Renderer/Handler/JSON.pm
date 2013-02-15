package Kukuru::Renderer::Handler::JSON;
use strict;
use warnings;
use JSON 2 ();

my $_JSON = JSON->new->utf8->ascii;
my %_ESCAPE = (
    '+' => '\\u002b', # do not eval as UTF-7
    '<' => '\\u003c', # do not eval as HTML
    '>' => '\\u003e', # ditto.
);

sub handler {
    my ($c, %vars) = @_;
    my $stuff  = $vars{json};
    my $status = $vars{status} || 200;

    # for IE7 JSON venularity.
    # see http://www.atmarkit.co.jp/fcoding/articles/webapp/05/webapp05a.html
    my $output = $_JSON->encode($stuff);
    $output =~ s!([+<>])!$_ESCAPE{$1}!g;

    my $user_agent = $c->req->user_agent || '';

    # defense from JSON hijacking
    if (
        (!$c->req->header('X-Requested-With')) &&
        $user_agent =~ /android/i              &&
        defined $c->req->header('Cookie')      &&
        ($c->req->method||'GET') eq 'GET'
    ) {
        my $res = $c->req->new_response(403);
        $res->content_type('text/plain; charset=utf-8');
        $res->content(<<"..."
Your request may be JSON hijacking.
If you are not an attacker, please add 'X-Requested-With' header to each request.
...
        );
        return $res;
    }

    # add UTF-8 BOM if the client is Safari
    if ( $user_agent =~ m/Safari/ and $encoding eq 'utf-8' ) {
        $output = "\xEF\xBB\xBF" . $output;
    }

    my $charset = $c->req->encoding->mime_name;
    my $headers = [
        "Content-Type"           => "application/json; charset=$charset",
        "X-Content-Type-Options" => "nosniff",
    ];

    $c->req->new_response($status, $headers, [$output]);
}

1;
