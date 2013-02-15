package Kukuru::Renderer::Handler::Text;
use strict;
use warnings;

sub handler {
    my ($c, %vars) = @_;
    my $charset      = $c->req->encoding->mime_name;
    my $output       = $vars{text};
    my $status       = $vars{status} || 200;
    my $content_type = $vars{type}   || "text/plain; charset=$charset";

    my $headers = [
        "Content-Type" => $content_type,
    ];

    $c->req->new_response($status, $headers, [$output]);
}

1;
