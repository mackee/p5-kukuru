use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use Mouse;
    extends 'Kukuru';
}

{
    package MyApp::HasController;
    use Mouse;
    extends 'Kukuru';

    package MyApp::HasController::Controller;
    use Mouse;
    extends 'Kukuru::Controller';
}

subtest 'doesnt have controller' => sub {
    my $conroller_class = 'MyApp::Controller';

    # Controllerが読み込まれていない事を確認
    eval { $conroller_class->meta };
    like $@, qr/Can't locate object method "meta" via package "MyApp::Controller/;

    # BUILD!
    my $app = MyApp->new;

    # metaがあることを確認
    eval { $conroller_class->meta };
    ok !$@;
};

subtest 'has controller' => sub {
    my $conroller_class = 'MyApp::HasController::Controller';

    # Controllerが読み込み済みか確認
    eval { $conroller_class->meta };
    ok !$@;

    # BUILD!
    my $app = MyApp->new;

    # metaがあることを確認
    eval { $conroller_class->meta };
    ok !$@;
};

done_testing;
