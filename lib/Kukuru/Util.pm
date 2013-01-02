package Kukuru::Util;
use strict;
use warnings;
use Mouse::Util;

sub load_class {
    my ($class, $prefix) = @_;

    if ($prefix) {
        unless ($class =~ s/^\+// || $class =~ /^$prefix/) {
            $class = "$prefix\::$class";
        }
    }

    Mouse::Util::load_class($class);
}

1;
