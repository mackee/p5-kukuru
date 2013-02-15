package Kukuru::Renderer::Handler::Text;
use strict;
use warnings;

sub handler {
    my ($c, %vars) = @_;
    my $output       = $vars{text};
    my $status       = $vars{status} || 200;
    my $content_type = $vars{type}   || "text/plain; charset=utf-8";

    my $headers = [
        "Content-Type"   => $content_type,
        "Content-Length" => length($output),
    ];

    $c->req->new_response($status, $headers, [$output]);
}

1;
