requires "perl" => "5.010001";

requires "Mouse" => "1.05";
requires "Plack" => "1.0018";
requires "Data::Util" => "0.60";
requires "JSON" => "2.53";
requires "Router::Simple" => "0.14";

on "author" => sub {
    requires "Module::Install::CPANfile";
    requires "Module::Install::AuthorTests";
    requires "Module::Install::TestTarget";
};

on "test" => sub {
    requires "Test::More" => "0.88";
    requires "Test::LeakTrace" => "0.14";
};
