package EnchoOchu::Web;
use strict;
use warnings;
use utf8;
use parent qw/EnchoOchu Amon2::Web/;
use File::Spec;

# dispatcher
use EnchoOchu::Web::Dispatcher;
sub dispatch {
    return (EnchoOchu::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::JSON',
    'Web::Auth', +{
        module => 'Twitter',
        on_finished => sub {
            my ($c, $access_token, $access_token_secret, $user_id, $screen_name) = @_;
            $c->session->set('user_id', $user_id);
            return $c->redirect('/'),
        },
    },
    '+EnchoOchu::Web::Plugin::Session',
);

# setup view
use EnchoOchu::Web::View;
{
    sub create_view {
        my $view = EnchoOchu::Web::View->make_instance(__PACKAGE__);
        no warnings 'redefine';
        *EnchoOchu::Web::create_view = sub { $view }; # Class cache.
        $view
    }
}

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

sub user {
    my ($c) = @_;
    return $c->session->get('user_id');
}

1;
