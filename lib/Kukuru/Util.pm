package Kukuru::Util;
use strict;
use warnings;
use Mouse::Util;
use Plack::MIME;

sub load_class {
    my ($class, $prefix) = @_;

    if ($prefix) {
        unless ($class =~ s/^\+// || $class =~ /^$prefix/) {
            $class = "$prefix\::$class";
        }
    }

    Mouse::Util::load_class($class);
}

sub find_content_type {
    my (%args) = @_;
    my $format  = $args{format} or Carp::croak("require format.");
    my $charset = $args{charset};

    my $type = Plack::MIME->mime_type(".$format");

    # MIME implementations must ignore any parameters
    # whose names they do not recognize.
    $type .= "; charset=$charset" if $charset;

    $type;
}

1;
