package Kukuru::Renderer::Handler::Data;
use strict;
use warnings;
use Plack::Util;
use Plack::MIME;

sub handler {
    my ($c, %vars) = @_;
    my $output = $vars{data};
    my $status = $vars{status} || 200;
    my $format = $vars{format} || "";
    my $content_type = $vars{type} || Plack::MIME->mime_type(".$format");

    if (!$content_type) {
        die "need format/type";
    }

    my $headers = [
        "Content-Type" => $content_type,
    ];

    $c->req->new_response($status, $headers, $output);
}

1;
