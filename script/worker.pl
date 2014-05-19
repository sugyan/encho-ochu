#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use File::Basename;
use File::Spec;
use lib File::Spec->catfile(dirname(__FILE__), '..', 'lib');

use AnyEvent::Twitter;
use AnyEvent::Twitter::Stream;
use EnchoOchu;
use Encode qw(encode_utf8 decode_utf8);
use Log::Minimal;

my $c = EnchoOchu->bootstrap;
my $conf = $c->config->{Auth}{Twitter};

my $cv = AE::cv;
my $listener =  AnyEvent::Twitter::Stream->new(
    consumer_key    => $conf->{consumer_key},
    consumer_secret => $conf->{consumer_secret},
    token           => $conf->{access_token},
    token_secret    => $conf->{access_token_secret},
    method => 'filter',
    follow => $c->config->{target},
    on_connect => sub {
        infof('connected.');
    },
    on_tweet => sub {
        my $tweet = shift;
        return unless $tweet->{text};
        return if $tweet->{user}{id_str} ne $c->config->{target}; # 本人のものだけ抽出
        return if $tweet->{in_reply_to_user_id_str};              # 返信は無視

        debugf(ddf($tweet));
        infof(encode_utf8($tweet->{text}));
        if (decode_utf8($tweet->{text}) =~ /(?:帰る|かえる)/) {
            my $members = $c->db->search('member');
            while (my $member = $members->next) {
                # 発動率30%とする
                if (rand() < 0.7) {
                    infof('%s was skipped', $member->screen_name);
                    next;
                }
                my $c1 = AE::cv;
                # ランダム秒数(1s~10s)待つ
                my $rand = 1.0 + rand(9);
                infof('%s: %f', $member->screen_name, $rand);
                my $w; $w = AE::timer $rand, 0, sub {
                    $c1->send;
                    undef $w;
                };
                $c1->cb(sub {
                    my $ua = AnyEvent::Twitter->new(
                        consumer_key    => $conf->{consumer_key},
                        consumer_secret => $conf->{consumer_secret},
                        token           => $member->access_token,
                        token_secret    => $member->access_token_secret,
                    );
                    my $c2 = AE::cv;
                    $ua->post('statuses/update', +{
                        status => sprintf('@%s おちゅ', $tweet->{user}{screen_name}),
                        in_reply_to_status_id => $tweet->{id_str},
                    }, sub {
                        my ($header, $response, $reason) = @_;
                        $c2->send($response);
                    });
                    $c2->cb(sub {
                        my $res = $c2->recv;
                        debugf(ddf($res));
                    });
                });
            }
        }
    },
);
$cv->recv;
