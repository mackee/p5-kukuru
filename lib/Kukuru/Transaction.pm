package Kukuru::Transaction;
use Mouse;

has [qw/app req/] => (
    is => 'rw',
    required => 1,
);

has match => (
    is => 'rw',
    default => sub { +{} },
);

no Mouse;

sub dispatch {
    my ($self) = @_;
    my $match = $self->match;

    $self->_dispatch($match);
}

sub _dispatch {
    my ($self, $match) = @_;
    my $action = $match->{action};

    if ((ref $action || '') eq 'ARRAY') {
        # 配列の場合は、Controllerぶん回す。
        for my $dest (@$action) {
            my $res = $self->_dispatch($dest);
            return $res if $res;
        }
    }
    else {
        my $klass = $self->select_controller_class($match);
        my $c = $klass->new(
            app  => $self->app,
            tx   => $self,
            args => $match, # 名前考える
        );

        $c->dispatch($match);
    }
}

sub select_controller_class {
    my ($self, $match) = @_;

    if ($match && $match->{controller}) {
        Kukuru::Util::load_class(
            $match->{controller}, $self->app->app_controller_class
        );
    }
    else {
        $self->app->app_controller_class;
    }
}


1;
