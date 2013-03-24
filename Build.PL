use strict;
use warnings;
use Module::Build::Pluggable qw(
    CPANfile
    GithubMeta
    ReadmeMarkdownFromPod
);

my $builder = Module::Build::Pluggable->new(
    license              => 'perl',
    dynamic_config       => 0,
    no_index             => { 'directory' => [ 'inc' ] },
    name                 => 'Kukuru',
    module_name          => 'Kukuru',
    requires             => { perl => '5.010001' },
    test_files           => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,
    create_readme        => 1,
    create_license       => 1,
    create_makefile_pl   => 'traditional',
);

$builder->create_build_script();
