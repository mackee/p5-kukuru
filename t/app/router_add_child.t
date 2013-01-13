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

my $app = MyApp->app;
my $app_user = MyApp::Routes::User->app;

for my $route (@{$app_user->router->routes}) {
    $app->router->add_child($route);
}

is scalar(@{$app->router->routes}), 2;

done_testing;
