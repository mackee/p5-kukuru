use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';

    sub startup {
        my ($self) = @_;

        $self->{is_started}++;
    }
}

subtest 'startup' => sub {
    my $app = MyApp->new;
    is $app->{is_started}, 1;
};

done_testing;
