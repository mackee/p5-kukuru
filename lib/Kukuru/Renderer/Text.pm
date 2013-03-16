package Kukuru::Renderer::Text;
use strict;
use warnings;
use Kukuru::Util;

sub handler {
    my ($c, %vars) = @_;
    my $charset      = $c->req->encoding->mime_name;
    my $output       = $vars{text};
    my $status       = $vars{status} || 200;
    my $format       = $vars{format} || "txt";
    my $content_type = $vars{type};

    if (!$content_type) {
        $content_type = Kukuru::Util::find_content_type(
            format  => $format,
            charset => $charset,
        )
    }

    $output = $c->req->encoding->encode($output);
    my $headers = [
        "Content-Type"   => $content_type,
        "Content-Length" => length($output),
    ];

    $c->req->new_response($status, $headers, [$output]);
}

1;
