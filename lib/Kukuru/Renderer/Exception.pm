package Kukuru::Renderer::Exception;
use strict;
use warnings;
use Kukuru::Renderer::Text;

sub handler {
    my ($c, %vars) = @_;

    $vars{text}   ||= $vars{exception} ||= "Died.";
    $vars{status} ||= 500;

    Kukuru::Renderer::Text::handler($c, %vars);
}

1;
