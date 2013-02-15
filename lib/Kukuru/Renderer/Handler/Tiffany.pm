package Kukuru::Renderer::Handler::Tiffany;
use strict;
use warnings;

sub handler {
    my ($c, %vars) = @_;
    my $charset      = $c->req->encoding->mime_name;
    my $template     = $vars{template};
    my $status       = $vars{status} || 200;
    my $content_type = $vars{type}   || "text/html; charset=$charset";
    my $output       = $c->app->template_engine->render($template, {c => $c, %vars});

    my $headers = [
        "Content-Type" => $content_type,
    ];

    $c->req->new_response($status, $headers, [$output]);
}

1;
