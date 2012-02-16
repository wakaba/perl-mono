package test::Mono::ID;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;
use lib file(__FILE__)->dir->parent->subdir('t', 'lib')->stringify;
use lib glob file(__FILE__)->dir->parent->subdir('modules', '*', 'lib')->stringify;
use base qw(Test::Class);
use Test::MoreMore;
use Mono::ID;

sub _is_ean : Test(18) {
    for (
        [undef, 0],
        ['', 0],
        ['abc', 0],
        ['12345670', 1, 'EAN8'],
        ['12345671', 0, 'EAN8 invalid check digit'],
        ['654871170043', 0, 'UPC12'],
        ['654871170044', 0, 'UPC12 invalid check digit'],
        ['0654871170043', 1, 'EAN13'],
        ['0654871170044', 0, 'EAN13 invalid check digit'],
        ['9784101115016', 1, 'ISBN13'],
        ['9784101115017', 0, 'ISBN13 invalid check digit'],
        ['978-4101115016', 0, 'ISBN13 with -'],
        ['41011151060', 0, 'ISBN10'],
        ['4101115061', 0, 'ISBN10 invalid check digit'],
        ['410111501X', 0, 'ISBN10 with X'],
        ['410111501x', 0, 'ISBN10 with x'],
        ['4101115010', 0, 'ISBN10 invalid check digit 2'],
        ['4-1011-15060', 0, 'ISBN10 with -'],
    ) {
        is_bool is_ean $_->[0], $_->[1], $_->[2] ? 'is_ean ' . $_->[2] : undef;
    }
}

sub _is_isbn10 : Test(19) {
    for (
        [undef, 0],
        ['', 0],
        ['abc', 0],
        ['12345670', 0, 'EAN8'],
        ['12345671', 0, 'EAN8 invalid check digit'],
        ['654871170043', 0, 'UPC12'],
        ['654871170044', 0, 'UPC12 invalid check digit'],
        ['0654871170043', 0, 'EAN13'],
        ['0654871170044', 0, 'EAN13 invalid check digit'],
        ['9784101115016', 0, 'ISBN13'],
        ['9784101115017', 0, 'ISBN13 invalid check digit'],
        ['978-4101115016', 0, 'ISBN13 with -'],
        ['4101115060', 1, 'ISBN10'],
        ['4101115061', 0, 'ISBN10 invalid check digit'],
        ['410111501X', 1, 'ISBN10 with X'],
        ['410111501x', 1, 'ISBN10 with x'],
        ['4101115010', 0, 'ISBN10 invalid check digit 2'],
        ['4-1011-15060', 1, 'ISBN10 with -'],
        ['B0012IJERO' => 0, 'ASIN'],
    ) {
        is_bool is_isbn10 $_->[0], $_->[1], $_->[2] ? 'is_isbn10 ' . $_->[2] : undef;
    }
}

sub _is_isbn13 : Test(19) {
    for (
        [undef, 0],
        ['', 0],
        ['abc', 0],
        ['12345670', 0, 'EAN8'],
        ['12345671', 0, 'EAN8 invalid check digit'],
        ['654871170043', 0, 'UPC12'],
        ['654871170044', 0, 'UPC12 invalid check digit'],
        ['0654871170043', 0, 'EAN13'],
        ['0654871170044', 0, 'EAN13 invalid check digit'],
        ['9784101115016', 1, 'ISBN13'],
        ['9784101115017', 0, 'ISBN13 invalid check digit'],
        ['978-4101115016', 1, 'ISBN13 with -'],
        ['9794101115015', 1, 'ISBN13 979'],
        ['4101115060', 0, 'ISBN10'],
        ['4101115061', 0, 'ISBN10 invalid check digit'],
        ['410111501X', 0, 'ISBN10 with X'],
        ['410111501x', 0, 'ISBN10 with x'],
        ['4101115010', 0, 'ISBN10 invalid check digit 2'],
        ['4-1011-15060', 0, 'ISBN10 with -'],
    ) {
        is_bool is_isbn13 $_->[0], $_->[1], $_->[2] ? 'is_isbn13 ' . $_->[2] : undef;
    }
}

sub _is_isbn : Test(19) {
    for (
        [undef, 0],
        ['', 0],
        ['abc', 0],
        ['12345670', 0, 'EAN8'],
        ['12345671', 0, 'EAN8 invalid check digit'],
        ['654871170043', 0, 'UPC12'],
        ['654871170044', 0, 'UPC12 invalid check digit'],
        ['0654871170043', 0, 'EAN13'],
        ['0654871170044', 0, 'EAN13 invalid check digit'],
        ['9784101115016', 1, 'ISBN13'],
        ['9784101115017', 0, 'ISBN13 invalid check digit'],
        ['978-4101115016', 1, 'ISBN13 with -'],
        ['9794101115015', 1, 'ISBN13 979'],
        ['4101115060', 1, 'ISBN10'],
        ['4101115061', 0, 'ISBN10 invalid check digit'],
        ['410111501X', 1, 'ISBN10 with X'],
        ['410111501x', 1, 'ISBN10 with x'],
        ['4101115010', 0, 'ISBN10 invalid check digit 2'],
        ['4-1011-15060', 1, 'ISBN10 with -'],
    ) {
        is_bool is_isbn $_->[0], $_->[1], $_->[2] ? 'is_isbn ' . $_->[2] : undef;
    }
}

sub _is_asin : Test(22) {
    for (
        [undef, 0],
        ['', 0],
        ['abc', 0],
        ['12345670', 0, 'EAN8'],
        ['12345671', 0, 'EAN8 invalid check digit'],
        ['654871170043', 0, 'UPC12'],
        ['654871170044', 0, 'UPC12 invalid check digit'],
        ['0654871170043', 0, 'EAN13'],
        ['0654871170044', 0, 'EAN13 invalid check digit'],
        ['9784101115016', 0, 'ISBN13'],
        ['9784101115017', 0, 'ISBN13 invalid check digit'],
        ['978-4101115016', 0, 'ISBN13 with -'],
        ['9794101115015', 0, 'ISBN13 979'],
        ['4101115060', 1, 'ISBN10'],
        ['4101115061', 0, 'ISBN10 invalid check digit'],
        ['410111501X', 1, 'ISBN10 with X'],
        ['410111501x', 1, 'ISBN10 with x'],
        ['4101115010', 0, 'ISBN10 invalid check digit 2'],
        ['4-1011-15060', 0, 'ISBN10 with -'],
        ['B0012IJERO', 1, 'ASIN'],
        ['B0012Ijero', 1, 'ASIN lowercase'],
        ['B00-12I-JERO', 0, 'ASIN with -'],
    ) {
        is_bool is_asin $_->[0], $_->[1], $_->[2] ? 'is_isbn ' . $_->[2] : undef;
    }
}

sub _isbn13_to_isbn10 : Test(42) {
    for (
        [undef, undef],
        ['', undef],
        ['abc', undef],
        ['12345670', undef, 'EAN8'],
        ['12345671', undef, 'EAN8 invalid check digit'],
        ['654871170043', undef, 'UPC12'],
        ['654871170044', undef, 'UPC12 invalid check digit'],
        ['0654871170043', undef, 'EAN13'],
        ['0654871170044', undef, 'EAN13 invalid check digit'],
        ['9784101115017', undef, 'ISBN13 invalid check digit'],
        ['4101115060', undef, 'ISBN10'],
        ['4101115061', undef, 'ISBN10 invalid check digit'],
        ['410111501X', undef, 'ISBN10 with X'],
        ['410111501x', undef, 'ISBN10 with x'],
        ['4101115010', undef, 'ISBN10 invalid check digit 2'],
        ['4-1011-1506-0', undef, 'ISBN10 with -'],
        ['9784003101018' => '4003101014'],
        ['9784101115061' => '4101115060'],
        ['9784101115016' => '410111501X'],
        ['978-4101115016' => '410111501X'],
        ['9794101115016' => undef],
    ) {
        is isbn13_to_isbn10 $_->[0], $_->[1], $_->[2] ? 'isbn13_to_isbn10 ' . $_->[2] : undef;
        is ean_to_asin $_->[0], $_->[1], $_->[2] ? 'isbn13_to_isbn10 ' . $_->[2] : undef;
    }
}

sub _isbn_to_asin : Test(22) {
    for (
        [undef, undef],
        ['', undef],
        ['abc', undef],
        ['12345670', undef, 'EAN8'],
        ['12345671', undef, 'EAN8 invalid check digit'],
        ['654871170043', undef, 'UPC12'],
        ['654871170044', undef, 'UPC12 invalid check digit'],
        ['0654871170043', undef, 'EAN13'],
        ['0654871170044', undef, 'EAN13 invalid check digit'],
        ['9784101115017', undef, 'ISBN13 invalid check digit'],
        ['4101115060', '4101115060', 'ISBN10'],
        ['4101115061', undef, 'ISBN10 invalid check digit'],
        ['410111501X', '410111501X', 'ISBN10 with X'],
        ['410111501x', '410111501X', 'ISBN10 with x'],
        ['4101115010', undef, 'ISBN10 invalid check digit 2'],
        ['4-1011-1506-0', '4101115060', 'ISBN10 with -'],
        ['9784003101018' => '4003101014'],
        ['9784101115061' => '4101115060'],
        ['9784101115016' => '410111501X'],
        ['978-4101115016' => '410111501X'],
        ['9794101115016' => undef],
        ['B0012IJERO' => undef, 'ASIN'],
    ) {
        is isbn_to_asin $_->[0], $_->[1], $_->[2] ? 'isbn_to_asin ' . $_->[2] : undef;
    }
}

__PACKAGE__->runtests;

1;
