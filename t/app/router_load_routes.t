use strict;
use warnings;
use Test::More;

{
    package MyApp;
    use strict;
    use warnings;
    use Kukuru::Lite;

    get '/' => sub { ... };

    __PACKAGE__->meta->make_immutable;
}

{
    package MyApp::Routes::User;
    use strict;
    use warnings;
    use Kukuru::Lite;

    get '/user' => sub { ... };

    __PACKAGE__->meta->make_immutable;
}

{
    package MyApp::Routes::Post;
    use strict;
    use warnings;
    use Kukuru::Lite;

    get '/post' => sub { ... };

    __PACKAGE__->meta->make_immutable;
}
my $app = MyApp->app;

$app->router->load_routes(qw(MyApp::Routes::User MyApp::Routes::Post));

is scalar(@{$app->router->routes}), 3;

done_testing;
