package Mono::ID;
use strict;
use warnings;
our $VERSION = '1.0';
use Exporter::Lite;

our @EXPORT = qw(
    is_ean
    is_isbn10
    is_isbn13
    is_isbn
    is_asin

    isbn13_to_isbn10
    ean_to_asin
    isbn_to_asin

    calculate_ean_check_digit
    calculate_isbn10_check_digit
);

sub calculate_ean_check_digit ($) {
    my ($ean) = @_;
    my $rev = join '', reverse split //, $ean;
    my $len = length($ean);

    my ($odd, $even);
    for (my $i = 1; $i < $len; $i++) {
        if ($i % 2 == 0) {
            $odd  += substr($rev, $i, 1);
        } else {
            $even += substr($rev, $i, 1);
        }
    }

    my $result = 10 - ($odd + ($even * 3)) % 10;
    $result = 0 if $result == 10;

    return $result;
}

sub calculate_isbn10_check_digit ($) {
    my ($isbn) = @_;
    $isbn =~ s/-//g;

    my $sum = 0;
    my $len = length($isbn);
    for (my $i = 0; $i < $len - 1; $i++) {
        $sum += substr($isbn, $i, 1) * (10 - $i);
    }
    my $res = 11 - ($sum % 11);
    return 'X' if $res == 10;
    return '0' if $res == 11;
    return $res;
}

sub is_ean ($) {
    my $ean = shift or return 0;
    return 0 unless $ean =~ /^[0-9]{8}(?:[0-9]{5})?$/;

    my $expected = substr($ean, -1, 1);
    return $expected eq calculate_ean_check_digit($ean);
}

sub is_isbn10 ($) {
    my $isbn = shift or return 0;
    $isbn =~ tr/-//d;
    return 0 unless $isbn =~ /^[0-9]{9}[0-9Xx]$/;
    my $expected = uc substr($isbn, -1, 1);
    return $expected eq calculate_isbn10_check_digit($isbn);
}

sub is_isbn13 ($) {
    my $isbn = shift or return 0;
    $isbn =~ tr/-//d;
    return length($isbn) == 13 && is_ean($isbn) && $isbn =~ /^97[89]/;
}

sub is_isbn ($) {
    my $isbn = shift or return 0;
    return is_isbn13 $isbn || is_isbn10 $isbn;
}

sub is_asin ($) {
    my $asin = shift or return 0;
    return 0 unless $asin =~ /\A[0-9A-Za-z]{10}\z/;
    if ($asin =~ /\A[0-9]{9}[0-9Xx]\z/) {
        return is_isbn10 $asin;
    }
    return 1;
}

sub isbn13_to_isbn10 ($) {
    my $isbn = shift or return undef;
    return undef unless is_isbn13 $isbn;
    return undef unless $isbn =~ /^978/;
    $isbn =~ tr/-//d;
    my $base = substr($isbn, 3, 9);
    return $base . calculate_isbn10_check_digit($base . '?');
}

# API-less convertion only
*ean_to_asin = \&isbn13_to_isbn10;

sub isbn_to_asin ($) {
    my $isbn = shift or return undef;
    $isbn =~ tr/-//d;
    if (is_isbn13 $isbn) {
        $isbn = isbn13_to_isbn10 $isbn;
    }
    if (is_isbn10 $isbn) {
        return uc $isbn;
    } else {
        return undef;
    }
}

1;
