#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use File::Basename;
use File::Spec;
use lib File::Spec->catfile(dirname(__FILE__), '..', 'lib');

use AnyEvent::Twitter::Stream;
use EnchoOchu;

my $config = EnchoOchu->bootstrap->config->{Auth}{Twitter};

my $cv = AE::cv;
my $listener =  AnyEvent::Twitter::Stream->new(
    consumer_key    => $config->{consumer_key},
    consumer_secret => $config->{consumer_secret},
    token           => $config->{access_token},
    token_secret    => $config->{access_token_secret},
    method => 'filter',
    follow => '193312424',
    on_tweet => sub {
        my $tweet = shift;
        print "$tweet->{user}{screen_name}: $tweet->{text}\n";
    },
);
$cv->recv;
