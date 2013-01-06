package Kukuru::Router;
use strict;
use warnings;
use parent 'Router::Simple';
use Carp ();

sub routes { shift->{routes} }

sub any {
    my $self = shift;
    $self->add_route(@_);
}

sub get {
    my $self = shift;
    $self->add_route([qw(GET HEAD)], @_);
}

sub options {
    my $self = shift;
    $self->add_route([qw(OPTIONS)], @_);
}

sub patch {
    my $self = shift;
    $self->add_route([qw(PATCH)], @_);
}

sub post {
    my $self = shift;
    $self->add_route([qw(POST)], @_);
}

sub put {
    my $self = shift;
    $self->add_route([qw(PUT)], @_);
}

sub del {
    my $self = shift;
    $self->add_route([qw(DELETE)], @_);
}

sub load_routes {
    my ($self, $base_class) = @_;

    $base_class  = Mouse::load_class($base_class);
    my @children = Module::Find::usesub($base_class);
    for my $child ($base_class, @children) {
        $base_class->router->add_child($_)
            for @{$child->router->routes};
    }
    ($base_class, @children);
}

sub add_route {
    my ($self, $method, $path, $dest, $opts) = @_;

    if (!$method || !$path || !$dest) {
        Carp::craok('required method/path/dest');
    }

    $opts ||= {};
    $opts->{method} = $method;

    $dest = $self->_build_dest($dest);
    if (!$dest->{action}) {
        Carp::croak("Can't find action at route");
    }

    $self->connect($path, $dest, $opts);
}

sub _build_dest {
    my ($self, $dest) = @_;

    my $dest_type = ref $dest;
    if ($dest_type eq 'CODE') {
        return {action => $dest};
    }
    elsif ($dest_type eq 'ARRAY') {
        my @dests = map { $self->_build_dest($_) } @$dest;
        return {action => \@dests};
    }
    elsif (!$dest_type) {
        my ($controller, $action) = split '#', $dest;
        return {controller => $controller, action => $action};
    }

    return $dest;
}

1;
