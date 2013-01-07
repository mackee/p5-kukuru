use strict;
use warnings;
use lib './lib';
use Plack::Builder;
use MyApp;

MyApp->to_psgi;
