package EnchoOchu::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'EnchoOchu::DB::Row';

table {
    name 'member';
    pk 'id';
    columns qw(id name access_token access_token_secret);
};

1;
