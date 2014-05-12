return +{
    'DBI' => [
        'dbi:mysql:dbname=encho_ochu', 'root', '',
        +{
            AutoCommit => 1,
            PrintError => 0,
            RaiseError => 1,
            ShowErrorStatement => 1,
            AutoInactiveDestroy => 1,
            mysql_enable_utf8 => 1,
            mysql_auto_reconnect => 0,
        },
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
