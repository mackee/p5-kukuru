use inc::Module::Install;

name 'Kukuru';
all_from 'lib/Kukuru.pm';

cpanfile;

tests_recursive;

WriteAll;
