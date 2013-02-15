package Kukuru::Renderer::Handler::Tiffany;
use strict;
use warnings;

sub handler {
    my ($c, %vars) = @_;
    my $template     = $vars{template};
    my $status       = $vars{status} || 200;
    my $content_type = $vars{type}   || "text/html; charset=utf-8";
    my $output       = $c->app->template_engine->render($template, {c => $c, %vars});

    my $headers = [
        "Content-Type" => $content_type,
    ];

    $c->req->new_response($status, $headers, [$output]);
}

1;
