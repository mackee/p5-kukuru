use strict;
use warnings;
use utf8;
use Test::More;
use Kukuru::ResponseBuilder;

subtest 'render with template' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;

    my $count = 0;
    $response_builder->add_handler(template => sub {
        my ($c, %vars) = @_;

        $count++;
        is $vars{handler},  'template';
        is $vars{template}, 'root/index';
    });

    my $c = 'dummy';
    is $count, 0;
    $response_builder->render($c, template => 'root/index');
    is $count, 1;
};

subtest 'render with hander' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;

    my $count = 0;
    $response_builder->add_handler(test => sub {
        my ($c, %vars) = @_;

        $count++;
    });

    my $c = 'dummy';
    is $count, 0;
    $response_builder->render($c, handler => 'test');
    is $count, 1;
};

subtest 'render without handler' => sub {
    my $response_builder = Kukuru::ResponseBuilder->new;

    my $c = 'dummy';
    eval { $response_builder->render($c, handler => 'hisaichi5518') };
    like $@, qr/No handler for "hisaichi5518" available/;
};

done_testing;
