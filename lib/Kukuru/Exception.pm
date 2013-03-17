package Kukuru::Exception;
use strict;
use warnings;
use overload q[""] => \&stringify, fallback => 1;
use Mouse;

has [qw/message file line/] => (
    is => 'rw',
);

no Mouse;

sub throw {
    my ($class, %args) = @_;
    my $message = $args{message};
    my $file    = $args{file};
    my $line    = $args{line};

    die $class->new(
        message => $message,
        file    => $file,
        line    => $line,
    );
}

sub croak {
    my ($class, $message) = @_;

    my @caller = caller(1);
    $class->throw(
        message => $message || 'Died.',
        file    => $caller[1],
        line    => $caller[2],
    );
}

sub croakf {
    my ($self, $format, @args) = @_;

    # callerをあれこれするためにこうする
    @_ = ($self, sprintf $format, @args);
    goto \&croak;
}
sub stringify {
    my ($self) = @_;
    sprintf '%s at %s line %d.', $self->message, $self->file, $self->line;
}

__PACKAGE__->meta->make_immutable;
