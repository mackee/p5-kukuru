package Kukuru::Renderer::Handler::Data;
use strict;
use warnings;
use Carp ();
use Plack::Util;
use Kukuru::Util;

sub handler {
    my ($c, %vars) = @_;
    my $output = $vars{data};
    my $status = $vars{status} || 200;
    my $format = $vars{format} || "";
    my $content_type = $vars{type};

    if (!$content_type && $format) {
        $content_type = Kukuru::Util::find_content_type(
            format  => $format,
            charset => $c->req->encoding->mime_name,
        );
    }
    Carp::croak("need type/format") if !$content_type;

    my $headers = [
        "Content-Length" => Plack::Util::content_length($output) || 0,
        "Content-Type"   => $content_type,
    ];

    $c->req->new_response($status, $headers, $output);
}

1;
