use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';

    sub startup {
        my ($self) = @_;
        $self->helpers->{fly} = sub {
            my $c = shift;
        };
    }

}

subtest 'add helpers' => sub {

    ok !MyApp::Controller->can('fly');

    # BUILD!
    my $app = MyApp->new;

    ok MyApp::Controller->can('fly');

};

done_testing;
