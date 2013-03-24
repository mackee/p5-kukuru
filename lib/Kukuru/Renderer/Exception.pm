package Kukuru::Renderer::Exception;
use strict;
use warnings;
use Kukuru::Renderer::Text;

sub handler {
    my ($tx, $c, %vars) = @_;

    $vars{text}   ||= $vars{exception} ||= "Died.";
    $vars{status} ||= 500;

    Kukuru::Renderer::Text::handler($tx, $c, %vars);
}

1;
