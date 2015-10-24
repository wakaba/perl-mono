package test::Test::Mono;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->parent->subdir('lib')->stringify;
use lib file(__FILE__)->dir->parent->parent->subdir('t', 'lib')->stringify;
use lib file(__FILE__)->dir->parent->parent->subdir('t_deps', 'modules', 'test-moremore', 'lib')->stringify;
use base qw(Test::Class);
use Test::Mono;
use Test::MoreMore;
use Mono::ID;

sub _create_asin : Test(3) {
    for (1..3) {
        my $asin = create_asin;
        ok is_asin $asin;
    }
}

sub _create_isbn10 : Test(3) {
    for (1..3) {
        my $isbn = create_isbn10;
        ok is_isbn10 $isbn;
    }
}

sub _create_broken_isbn10 : Test(6) {
    for (1..3) {
        my $isbn = create_broken_isbn10;
        ng is_isbn10 $isbn;
        is length $isbn, 10;
    }
}

sub _create_isbn13 : Test(3) {
    for (1..3) {
        my $isbn = create_isbn13;
        ok is_isbn13 $isbn;
    }
}

sub _create_broken_isbn13 : Test(6) {
    for (1..3) {
        my $isbn = create_broken_isbn13;
        ng is_isbn13 $isbn;
        is length $isbn, 13;
    }
}

sub _create_ean13 : Test(6) {
    for (1..3) {
        my $ean = create_ean13;
        ok is_ean $ean;
        ng is_isbn13 $ean;
    }
}

__PACKAGE__->runtests;

1;
