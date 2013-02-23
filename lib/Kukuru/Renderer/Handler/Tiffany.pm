package Kukuru::Renderer::Handler::Tiffany;
use strict;
use warnings;

sub handler {
    my ($c, %vars) = @_;
    my $charset      = $c->req->encoding->mime_name;
    my $template     = $vars{template};
    my $status       = $vars{status} || 200;
    my $format       = $vars{format} || 'html';
    my $content_type = $vars{type};
    my $output       = $c->app->template_engine->render($template, {c => $c, %vars});

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
