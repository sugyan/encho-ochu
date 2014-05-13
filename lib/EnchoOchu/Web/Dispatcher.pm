package EnchoOchu::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

any '/' => sub {
    my ($c) = @_;
    my $count = $c->db->count('member' => '*');
    return $c->render('index.tx', {
        count => $count,
    });
};

get '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

post '/account/delete' => sub {
    my ($c) = @_;
    $c->user->delete();
    $c->session->expire();
    return $c->redirect('/');
};

1;
