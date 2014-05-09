use File::Spec;
use File::Basename qw(dirname);
my $basedir = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__), '..'));
my $dbpath = File::Spec->catfile($basedir, 'db', 'development.db');
return +{
    'DBI' => [
        "dbi:SQLite:dbname=$dbpath", '', '',
        +{
            sqlite_unicode => 1,
        }
    ],
    'Auth' => +{
        'Twitter' => +{
            consumer_key        => $ENV{consumer_key},
            consumer_secret     => $ENV{consumer_secret},
            access_token        => $ENV{access_token},
            access_token_secret => $ENV{access_token_secret},
        },
    },
};
