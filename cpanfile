requires 'Mouse' => 1.02;
requires 'Text::Xslate' => 2.0000;
requires 'Router::Simple' => 0.14;
requires 'parent' => 0.225;
requires 'URI' => 1.59;
requires 'Plack' => 0.9986;
requires 'Plack::Middleware::Session' => 0.15;


on test => sub {
    requires 'Test::More' => 0.98;
    requires 'Test::LeakTrace' => 0.14;
    requires 'HTTP::Request::Common' => 6.00;
};

on configure => sub {
    requires 'Module::Build' => 0.4003;
    requires 'Module::Build::Pluggable';
    requires 'Module::Build::Pluggable::GithubMeta';
    requires 'Module::Build::Pluggable::CPANfile';
    requires 'Module::Build::Pluggable::ReadmeMarkdownFromPod';
};
